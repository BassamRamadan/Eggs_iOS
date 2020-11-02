//
//  cart.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/14/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class cart: common{
    @IBOutlet var cartCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartCollection.delegate = self
        cartCollection.dataSource = self
    }
}
extension cart: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.CartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cart", for: indexPath) as! cartCell
        let data = AppDelegate.CartProducts[indexPath.row]
        cell.plus.tag = indexPath.row
        cell.minus.tag = indexPath.row
        cell.remove.tag = indexPath.row
        cell.title.text = data.title ?? ""
        cell.image.sd_setImage(with: URL(string: data.image ?? ""))
        cell.salary.text = data.price ?? "0"
        cell.count.text = "\(data.count ?? 1)"
        return cell
    }
    
    
}
