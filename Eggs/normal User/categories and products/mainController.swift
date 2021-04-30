//
//  mainController.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/8/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class mainController: ContentViewController {

    @IBOutlet var categoryCollection: UICollectionView!
    @IBOutlet var productsCollection: UICollectionView!
    
    @IBOutlet var categoriesView: UIView!
    @IBOutlet var productsView: UIView!
    
    @IBOutlet var productsCount: UILabel!
    @IBOutlet var productsCategory: UILabel!
    
    
    var categoryIndex: Int = 0
    var categoryId: Int = 0
    var page = 1
    var categories: categoriesData?
    var products: productsData?
    var favProducts = [productData]()
    var productsUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionViewaDelegation()
        getCategory()
        setupBackButtonWithPOP()
    }
    func someMethodsWantToCall(cell: UICollectionViewCell,isFav: Bool){
        guard let cell = cell as? productCell else {
            return
        }
        let indexPath = productsCollection.indexPath(for: cell)!
        if isFav{
            favProducts.append((self.products?.data?[indexPath.row])!)
        }else{
            let indx: Any? = favProducts.firstIndex(where: {$0.id == (products?.data?[indexPath.row].id ?? 0)})
            if indx != nil {favProducts.remove(at: indx as! Int)}
        }
        productsCollection.reloadItems(at: [indexPath])
    }
    func getMyFav(){
        getFavProducts{
            newFavProducts,data  in
            self.favProducts.removeAll()
            self.favProducts.append(contentsOf: newFavProducts)
            if self.page == 2{
                self.productsCollection.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if page == 2{
            callProducts()
        }
    }
    fileprivate func  callProducts(){
        let url = productsUrl == nil ? AppDelegate.LocalUrl + "product?cat_id=\(categories?.categoryItems?[categoryIndex].id ?? 0)" : (productsUrl ?? "")
        getProducts(url: url){
            data in
            self.products = data
            self.getMyFav()
            self.productsCount.text = "\(self.products?.data?.count ?? 0)"
            self.productsCategory.text = self.categories?.categoryItems?[self.categoryIndex].title
        }
    }
    override func setupBackButtonWithPOP(_ pop:Bool? = true) {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        backBtn.addTarget(self, action: #selector(self.back), for: UIControl.Event.touchUpInside)
        if AppDelegate.lang == "en"{
            self.navigationItem.setLeftBarButton(backButton, animated: true)
        }else{
            self.navigationItem.setRightBarButton(backButton, animated: true)
        }
    }
    @objc func back(){
        currentPageToAppear(false)
    }

    fileprivate func collectionViewaDelegation() {
        productsCollection.register(UINib(nibName: "productsCollectionView", bundle: nil), forCellWithReuseIdentifier: "products")
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        productsCollection.delegate = self
        productsCollection.dataSource = self
    
        categoriesView.isHidden = false
        productsView.isHidden = true
    }
    fileprivate func currentPageToAppear(_ next: Bool? = true){
        if (next == true){
            page += 1
        }else{
            page -= 1
            page = max(1,page)
        }
        if page == 2{
            productsCollection.reloadData()
        }else{
            categoryCollection.reloadData()
        }
        categoriesView.isHidden = (page == 2)
        productsView.isHidden = (page != 2)
    }
    @IBAction func openFilters(){
        if products?.data?.count ?? 0 > 0{
            let storyboard = UIStoryboard(name: "Filtering", bundle: nil)
            let linkingVC = storyboard.instantiateViewController(withIdentifier: "Filtering") as! UINavigationController
            let des = linkingVC.viewControllers[0] as! filters
            des.parentId = Int(products?.data?[0].catID ?? "0") ?? 0
            des.isEggs = false
            des.parentController = self
            linkingVC.modalPresentationStyle = .fullScreen
            self.present(linkingVC,animated: true,completion: nil)
        }
    }
}
extension mainController: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundView = nil
        
        if collectionView == categoryCollection{
            if (categories?.categoryItems?.count ?? 0 == 0){
                noDataAvailable(collectionView)
            }
            return categories?.categoryItems?.count ?? 0
        }else{
            if (products?.data?.count ?? 0 == 0){
                noDataAvailable(collectionView)
            }
            return products?.data?.count ?? 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection{
            return .init(width: collectionView.frame.width, height: 150)
        }else{
            return .init(width: (collectionView.frame.width - 10)/2, height: 350)
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productCell
            cell.addToCart.isHidden = true
            if let data = products?.data?[indexPath.row]{
                cell.link = self
                cell.setupCellData(data: data)
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if collectionView == productsCollection{
            openProductDetails(productId: products?.data?[indexPath.row].id ?? 0)
        }else{
            categoryId = categories?.categoryItems?[indexPath.row].id ?? 0
            categoryIndex = indexPath.row
            productsUrl = nil
            currentPageToAppear()
            callProducts()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == categoryCollection{
            return 0
        }else{
            return 15
        }
    }
}
extension mainController {
    fileprivate func getCategory() {
        self.loading()
        let url = AppDelegate.LocalUrl + "product/category"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "lang": AppDelegate.lang,
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
    
}
