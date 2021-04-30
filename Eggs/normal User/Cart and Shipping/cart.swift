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
    @IBOutlet var totalCost: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButtonWithPOP(false)
        totalCost.text = AppDelegate.calculateCosts()
        cartCollection.delegate = self
        cartCollection.dataSource = self
    }
    
    @IBAction func plus(sender: UIButton){
        if AppDelegate.CartItems[sender.tag].count ?? 0 <= AppDelegate.CartItems[sender.tag].branchItems ?? 0{
            AppDelegate.CartItems[sender.tag].count = (AppDelegate.CartItems[sender.tag].count ?? 0) + 1
            totalCost.text = AppDelegate.calculateCosts()
            cartCollection.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
        }
    }
    @IBAction func minus(sender: UIButton){
        if AppDelegate.CartItems[sender.tag].count == 1{
            return
        }
        AppDelegate.CartItems[sender.tag].count = (AppDelegate.CartItems[sender.tag].count ?? 0) - 1
        totalCost.text = AppDelegate.calculateCosts()
        cartCollection.reloadItems(at: [IndexPath(row: sender.tag, section: 0)])
    }
    @IBAction func removeItemFromCart(sender: UIButton){
        AppDelegate.CartItems.remove(at: sender.tag)
        totalCost.text = AppDelegate.calculateCosts()
        cartCollection.reloadData()
    }
    @IBAction func completeOrder(){
        OpenCartNavigations(NavigationName: "payment")
    }
}
extension cart: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.CartItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cart", for: indexPath) as! cartCell
        let data = AppDelegate.CartItems[indexPath.row]
        cell.plus.tag = indexPath.row
        cell.minus.tag = indexPath.row
        cell.remove.tag = indexPath.row
        cell.title.text = data.title ?? ""
        cell.image.sd_setImage(with: URL(string: data.image ?? ""))
        cell.salary.text = data.price ?? "0"
        cell.count.text = "\(data.count ?? 1)"
        cell.info.text = data.info ?? ""
        cell.section.text = data.catName ?? ""
        cell.brand.text = data.brand ?? ""
        
        cell.available.text = (data.count ?? 0 > data.branchItems ?? 0) ? "not available" : "available"
        cell.available.textColor = (data.count ?? 0 > data.branchItems ?? 0) ? .red : UIColor(named: "light")
        cell.notAvailable.text = (data.count ?? 0 > data.branchItems ?? 0) ? "stored \(data.branchItems ?? 0)" : ""
        cell.notAvailable.isHidden = (data.count ?? 0 <= data.branchItems ?? 0)
        cell.count.delegate = self
        cell.count.tag = indexPath.row
        return cell
    }
}
extension cart: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        AppDelegate.CartItems[textField.tag].count = Int(textField.text ?? "1")
        totalCost.text = AppDelegate.calculateCosts()
        cartCollection.reloadItems(at: [IndexPath(row: textField.tag, section: 0)])
    }
}
