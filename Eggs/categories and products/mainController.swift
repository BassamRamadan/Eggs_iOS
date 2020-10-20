//
//  mainController.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/8/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class mainController: common {

    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var productsCollection: UICollectionView!
    
    @IBOutlet var categoriesView: UIView!
    @IBOutlet var productsView: UIView!
    
    var page = 1
    var categories: categoriesData?
    var products: productsData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesView.isHidden = false
        productsView.isHidden = true
        collectionViewaDelegation()
        getCategory()
        setupBackButtonWithPOP()
        
    }
    override func setupBackButtonWithPOP(_ pop:Bool? = true) {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControl.Event.touchUpInside)
        if AppDelegate.isEnglish{
            self.navigationItem.setLeftBarButton(backButton, animated: true)
        }else{
            self.navigationItem.setRightBarButton(backButton, animated: true)
        }
    }
    @objc func back(){
        currentPageToAppear(false)
    }

    fileprivate func collectionViewaDelegation() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        productsCollection.delegate = self
        productsCollection.dataSource = self
    }
    fileprivate func currentPageToAppear(_ next: Bool? = true){
        if (next == true){
            page += 1
        }else{
            page -= 1
        }
        categoriesView.isHidden = (page == 2)
        productsView.isHidden = (page == 1)
        productsCollection.reloadData()
    }
    
    @IBAction func openFilters(){
        if products?.data?.count ?? 0 > 0{
            let storyboard = UIStoryboard(name: "Filtering", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "Filtering") as! UINavigationController
            let des = linkingVC.viewControllers[0] as! filters
            des.parentId = Int(products?.data?[0].catID ?? "0") ?? 0
            des.isEggs = false
            self.present(linkingVC,animated: true,completion: nil)
        }
    }
    fileprivate func getCategory() {
        self.loading()
        let url = AppDelegate.LocalUrl + "product/category"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "lang": "en",
            "country_id": "187"
        ]
        AlamofireRequests.getMethod(url: url,headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataRecived = try decoder.decode(categoryJson.self, from: jsonData)
                        self.categories = dataRecived.data
                        self.categoryCollection.reloadData()
                        self.stopAnimating()
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
    fileprivate func getProduct(categoryId: Int) {
        self.loading()
        let url = AppDelegate.LocalUrl + "product?cat_id=\(categoryId)"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "lang": "en",
            "country_id": "187"
        ]
        AlamofireRequests.getMethod(url: url,headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        let dataRecived = try decoder.decode(productsJson.self, from: jsonData)
                        self.products = dataRecived.data
                        self.productsCollection.reloadData()
                        self.stopAnimating()
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                        self.stopAnimating()
                    }
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.stopAnimating()
                }
            }catch {
                self.present(common.makeAlert(), animated: true, completion: nil)
                self.stopAnimating()
            }
        }
    }
}
extension mainController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollection{
            return categories?.categoryItems?.count ?? 0
        }else{
            return products?.data?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection{
            return .init(width: collectionView.frame.width, height: 150)
        }else{
            return .init(width: (collectionView.frame.width - 10)/2, height: 310)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath) as! categoryCell
            if let dataCell = categories?.categoryItems?[indexPath.row]{
                cell.title.text = dataCell.title ?? ""
                cell.note.text = dataCell.note ?? ""
                cell.image.sd_setImage(with: URL(string: dataCell.image ?? ""))
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "details", for: indexPath) as! productCell
            let data = products?.data?[indexPath.row]
            cell.image.sd_setImage(with: URL(string: data?.image ?? ""))
            cell.title.text = data?.title ?? ""
            cell.fav.tag = data?.id ?? 0
            cell.salary.text = data?.price ?? "0"
            cell.rate.rating = Double(data?.rate ?? 0)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentPageToAppear()
        getProduct(categoryId: categories?.categoryItems?[indexPath.row].id ?? 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollection{
            return 0
        }else{
            return 15
        }
    }
}