//
//  productDetails.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/23/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
class productDetailsController: common{
    
    @IBOutlet var relatedCollection: UICollectionView!
    var horizontalScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var topView: UIView!
    
    @IBOutlet var name: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var rate: CosmosView!
    @IBOutlet var brand: UILabel!
    @IBOutlet var brandImage: UIImageView!
    @IBOutlet var seller: UILabel!
    @IBOutlet var sellerType: UILabel!
    @IBOutlet var note: UILabel!
    @IBOutlet var code: UILabel!
    @IBOutlet var sectionName: UILabel!
    @IBOutlet var volumeName: UILabel!
    @IBOutlet var sizeName: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var brand2: UILabel!
    @IBOutlet var sectionName2: UILabel!
    @IBOutlet var littleInfo: UILabel!
    @IBOutlet var rateAsRatio: UILabel!
    @IBOutlet var rateAsNumber: UILabel!
    @IBOutlet var rate2: CosmosView!
    @IBOutlet var fav: UIBarButtonItem!
    @IBOutlet var CartProductNumber: UILabel!
    
    var isFav = false
    var productId = 0
    var product: productDetails?
    var favProducts = [productData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setupBackButtonWithPOP(false)
        getProductDetails()
    }
    fileprivate func setupViews(){
        rate2.didFinishTouchingCosmos = { rating in
            self.addRate(productId: self.productId, rate: rating, isProduct: true){
                ok in
                if ok{
                    self.rateAsNumber.text = "\((rating))"
                }
            }
        }
        relatedCollection.register(UINib(nibName: "productsCollectionView", bundle: nil), forCellWithReuseIdentifier: "products")
        
        relatedCollection.delegate = self
        relatedCollection.dataSource = self
        CartProductNumber.text = "\(AppDelegate.CartProducts.count)"
        CartProductNumber.isHidden = AppDelegate.CartProducts.count == 0
    }
    func getMyFav(){
        getFavProducts{
            newFavProducts,data  in
            self.favProducts.removeAll()
            self.favProducts.append(contentsOf: newFavProducts)
            self.relatedCollection.reloadData()
        }
    }
    fileprivate func setupDate(){
        name.text = product?.title ?? ""
        price.text = product?.price ?? "0"
        rate.rating = Double(product?.rate ?? 0)
        rateAsRatio.text = "\(Int((rate.rating/5.0)*100))%"
        brand.text = product?.brand ?? ""
        brand2.text = product?.brand ?? ""
        brandImage.sd_setImage(with: URL(string: product?.brandImage ?? ""))
        seller.text = product?.seller ?? ""
        sellerType.text = product?.sellerType ?? ""
        note.text = product?.note ?? ""
        code.text = product?.code ?? ""
        sectionName.text = product?.catName ?? ""
        sectionName2.text = product?.catName ?? ""
        sizeName.text = product?.sizeName ?? ""
        categoryName.text = product?.catName ?? ""
        volumeName.text = product?.volumeName ?? ""
        littleInfo.text = (product?.sectionName ?? "") + (product?.sizeName ?? "")
        fav.image = (isFav ? #imageLiteral(resourceName: "ic_ac_fav_active") : #imageLiteral(resourceName: "ic_ac_fav")).withRenderingMode(.alwaysOriginal)
    }
    @IBAction func ToFav(){
        if self.fav.image?.pngData() == #imageLiteral(resourceName: "ic_ac_fav").pngData(){
            addToFav(productId: productId, product: true){
                ok in
                self.fav.image = #imageLiteral(resourceName: "ic_ac_fav_active").withRenderingMode(.alwaysOriginal)
            }
        }else{
            removeProductFromFav(product: true, productId: productId){
                ok in
                self.fav.image = #imageLiteral(resourceName: "ic_ac_fav").withRenderingMode(.alwaysOriginal)
            }
        }
    }
    func someMethodsWantToCall(cell: UICollectionViewCell,isFav: Bool){
        guard let cell = cell as? productCell else {
            return
        }
        let indexPath = relatedCollection.indexPath(for: cell)!
        if isFav{
            favProducts.append((product?.sellerProducts?[indexPath.row])!)
        }else{
            let indx: Any? = favProducts.firstIndex(where: {$0.id == (product?.sellerProducts?[indexPath.row].id ?? 0)})
            if indx != nil {favProducts.remove(at: indx as! Int)}
        }
        relatedCollection.reloadItems(at: [indexPath])
    }
    @IBAction func leftImage(){
        if pageControl.currentPage != 0{
            horizontalScrollView.contentOffset.x -= horizontalScrollView.bounds.width
            updatePageControl(horizontalScrollView)
        }
    }
    @IBAction func rightImage(){
        if (pageControl.currentPage+1) < (product?.images?.count ?? 0){
            horizontalScrollView.contentOffset.x += horizontalScrollView.bounds.width
            updatePageControl(horizontalScrollView)
        }
    }
    fileprivate func setupHorizontalScrollView(){
        horizontalScrollView = UIScrollView(frame: .init(x: 0, y: 0, width: topView.frame.width, height: topView.frame.height))
        horizontalScrollView.delegate = self
        horizontalScrollView.isPagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.showsVerticalScrollIndicator = false
        topView.addSubview(horizontalScrollView)
        let items = HorizontalItemList(inView: self.topView,arrangedSubviews: product?.images ?? [])
        horizontalScrollView.addSubview(items)
        items.fillSuperview()
        
        pageControl.numberOfPages = product?.images?.count ?? 0
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
}
extension productDetailsController{
     func getProductDetails() {
        self.loading()
        let url = AppDelegate.LocalUrl + "product/details/\(productId)"
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
                        let dataRecived = try decoder.decode(productDetailsJson.self, from: jsonData)
                        self.getMyFav()
                        self.product = dataRecived.data
                        self.setupDate()
                        self.setupHorizontalScrollView()
                        self.relatedCollection.reloadData()
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
extension productDetailsController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.sellerProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productCell
        if let data = product?.sellerProducts?[indexPath.row]{
            cell.link = self
            cell.setupCellData(data: data, isFav: favProducts.firstIndex(where: {$0.id == data.id}) != nil)
        }
        return cell
    }
    
    
}
extension productDetailsController: UIScrollViewDelegate{
    fileprivate func updatePageControl(_ scrollView: UIScrollView) {
        let pagWidth = scrollView.bounds.width
        pageControl.currentPage = Int(scrollView.contentOffset.x / pagWidth)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == horizontalScrollView{
            updatePageControl(scrollView)
        }
    }
}
