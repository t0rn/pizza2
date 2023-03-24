//
//  PizzaViewController.swift
//  pizza2
//
//  Created by admin on 24.03.2023.
//

import UIKit
import Kingfisher


class PizzaViewController: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let fetcher = ConfigFetcher()
    var config : AppConfig?{
        
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        fetchData()
        
    }

    func fetchData (){
        fetcher.fetchConfig{ [weak self] (error , config) -> Void in
            if let error = error{
                return
            }
            self?.config = config
        }
    }

}

extension PizzaViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return config?.productList.promotionList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath)
        
        if
        let myCell = cell as? MyCollectionViewCell,
        let promotion = config?.productList.promotionList[indexPath.row]{
            myCell.titleLabel.text = promotion.title
            let url = URL(string: promotion.imageLink)!
            myCell.imagePizza.kf.setImage(with: Source.network(url))
        }
        return cell
            
        
    }
    
    
}

extension PizzaViewController : UICollectionViewDelegate{
    
}

extension PizzaViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        config?.productList.pizzaList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaTableViewCell", for: indexPath)
        
        if
            let myCell = cell as? PizzaTableViewCell,
            let pizza = config?.productList.pizzaList[indexPath.row]{
            let arr = min(pizza.price.small ?? 9999, pizza.price.medium ?? 9999, pizza.price.large ?? 9999)
            myCell.pizzaTitleCell.text = "\(pizza.title) от \(arr) р."
            
        }
        return cell
           
    }
    
    
}

extension PizzaViewController : UITableViewDelegate{
    
}
