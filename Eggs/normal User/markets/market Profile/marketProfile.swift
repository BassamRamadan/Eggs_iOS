//
//  marketProfile.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/14/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
import DropDown
class marketProfile: common{
    @IBOutlet var name: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var rate: CosmosView!
    @IBOutlet var ratio: UILabel!
    @IBOutlet var productsCollection: UICollectionView!
    @IBOutlet var branchButton: UIButton!
    @IBOutlet var selectedBranch: UILabel!
    @IBOutlet var productsButton: UIButton!
    
    
    var products: productsData?
    var marketData : categoryData?
    var branches = [branchData]()
    var branchesDropdown = DropDown()
    var isProductsAppeared = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    
        getBranches(id: marketData?.id ?? 0) { (data) in
            self.branches.removeAll()
            self.branches.append(contentsOf: data)
            if data.count > 0{
                self.selectedBranch.text = data[0].name ?? ""
                self.callProducts(branchId: data[0].id ?? 0)
            }
        }
        setupDelegation()
        setupData()
        setupBackButtonWithPOP(false)
    }
    
    @IBAction func dropDown(_ sender: UIButton) {
        branchesDropdown.anchorView = (sender as AnchorView)
        branchesDropdown.dataSource = parsingData(self.branches )
        branchesDropdown.bottomOffset = CGPoint(x: 0, y:(branchesDropdown.anchorView?.plainView.bounds.height)!)
        branchesDropdown.selectionAction = {
            [unowned self](index : Int , item : String) in
            self.selectedBranch.text = item
            self.callProducts(branchId: self.branches[index].id ?? 0)
        }
        branchesDropdown.show()
    }
    fileprivate func parsingData(_ data : [branchData])->[String]{
        var ResData = [String]()
        for x in data {
            ResData.append("\(x.name ?? "")")
        }
        return ResData
    }
    
    fileprivate func setupData(){
        name.text = marketData?.name ?? ""
        image.sd_setImage(with: URL(string: marketData?.image ?? ""))
        rate.rating = Double(marketData?.rate ?? 0)
        ratio.text = "\(Int((rate.rating/5.0)*100))%"
    }
    fileprivate func setupDelegation(){
        productsCollection.register(UINib(nibName: "productsCollectionView", bundle: nil), forCellWithReuseIdentifier: "products")
        productsCollection.register(UINib(nibName: "branch", bundle: nil), forCellWithReuseIdentifier: "branches")
        productsCollection.delegate = self
        productsCollection.dataSource = self
     
    }
    @IBAction func switchButtons(sender: UIButton){
        sender.setTitleColor(.white, for: .normal)
        if sender == productsButton{
            isProductsAppeared = true
            branchButton.setTitleColor(.lightText, for: .normal)
        }else{
            isProductsAppeared = false
            productsButton.setTitleColor(.lightText, for: .normal)
        }
        productsCollection.reloadData()
    }
    fileprivate func  callProducts(branchId: Int){
        let url = AppDelegate.LocalUrl + "product?user_id=\(marketData?.id ?? 0)&branch_id=\(branchId)"
        getProducts(url: url){
            data in
            self.products = data
            self.productsCollection.reloadData()
        }
    }
    @IBAction func completeOrder() {
        if AppDelegate.CartItems.count > 0{
            OpenCartNavigations(NavigationName: "cart")
        }
    }
}
extension marketProfile: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let count = isProductsAppeared ? products?.data?.count ?? 0 : branches.count
        collectionView.backgroundView = nil
        if count == 0{
            noDataAvailable(collectionView)
        }
        return count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isProductsAppeared{
            return .init(width: (collectionView.frame.width - 10)/2, height: 400)
        }else{
            return .init(width: collectionView.frame.width, height: 150)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isProductsAppeared{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productCell
            if let data = products?.data?[indexPath.row]{
                cell.link = self
                cell.setupCellData(data: data)
                cell.addToCart.addTarget(self, action: #selector(toProductDetails(sender:)), for: .touchUpInside)
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "branches", for: indexPath) as! branchCell
            cell.name.text = branches[indexPath.row].name ?? ""
            cell.location.text = "\(branches[indexPath.row].cityName ?? "") - \(branches[indexPath.row].districtName ?? "")"
            cell.phone.tag = indexPath.row
            cell.map.tag = indexPath.row
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
    
    @objc func toProductDetails(sender: UIButton){
        openProductDetails(productId: sender.tag)
    }
   
}
