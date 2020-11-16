//
//  marketProfile.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/14/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
class marketProfile: common{
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var rate: CosmosView!
    @IBOutlet var ratio: UILabel!
    @IBOutlet var productsCollection: UICollectionView!
    @IBOutlet var branchesCollection: UICollectionView!
    @IBOutlet var branchButton: UIButton!
    @IBOutlet var productsButton: UIButton!
    
    var products: productsData?
    var favProducts = [productData]()
    var marketData : categoryData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegation()
        setupData()
        setupBackButtonWithPOP(false)
    }
    fileprivate func setupData(){
        name.text = marketData?.name ?? ""
        image.sd_setImage(with: URL(string: marketData?.image ?? ""))
        rate.rating = Double(marketData?.rate ?? 0)
        ratio.text = "\(Int((rate.rating/5.0)*100))%"
    }
    fileprivate func setupDelegation(){
        productsCollection.register(UINib(nibName: "productsCollectionView", bundle: nil), forCellWithReuseIdentifier: "products")
        productsCollection.delegate = self
        productsCollection.dataSource = self
        callProducts()
     //   branchesCollection.delegate = self
     //   branchesCollection.dataSource = self
    }
    @IBAction func switchButtons(sender: UIButton){
        sender.setTitleColor(.white, for: .normal)
        if sender == productsButton{
            branchButton.setTitleColor(.lightText, for: .normal)
        }else{
            productsButton.setTitleColor(.lightText, for: .normal)
        }
    }
    fileprivate func  callProducts(){
        let url = AppDelegate.LocalUrl + "product?user_id=\(marketData?.id ?? 0)&branch_id=\(2)"
        getProducts(url: url){
            data in
            self.products = data
            self.productsCollection.reloadData()
        }
    }

}
extension marketProfile: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == productsCollection{
            return products?.data?.count ?? 0
        }else{
            return  0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productsCollection{
            return .init(width: (collectionView.frame.width - 10)/2, height: 350)
        }else{
            return .init(width: collectionView.frame.width, height: 150)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == productsCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productCell
            let data = products?.data?[indexPath.row]
            cell.image.sd_setImage(with: URL(string: data?.image ?? ""))
            cell.title.text = data?.title ?? ""
            cell.fav.tag = indexPath.row
            if favProducts.firstIndex(where: {$0.id == data?.id}) != nil{
                cell.fav.setImage(#imageLiteral(resourceName: "ic_ac_fav_active").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.fav.setImage(#imageLiteral(resourceName: "ic_ac_fav").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            cell.salary.text = data?.price ?? "0"
            cell.rate.rating = Double(data?.rate ?? 0)
            cell.users.text = "\(Int((cell.rate.rating/5.0)*100))%"
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branches", for: indexPath) as! categoryCell
            
            return cell
        }
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == productsCollection{
            return 15
        }else{
            return 0
        }
    }
}
