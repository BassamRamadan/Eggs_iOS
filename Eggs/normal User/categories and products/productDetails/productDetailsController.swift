//
//  productDetails.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/23/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
import PopupDialog
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
    
    @IBOutlet var categoryValue: UILabel!
    @IBOutlet var typeOrColorValue: UILabel!
    @IBOutlet var sectionOrSizeValue: UILabel!
    @IBOutlet var weightOrVolumeValue: UILabel!
    
    @IBOutlet var category: UILabel!
    @IBOutlet var typeOrColor: UILabel!
    @IBOutlet var sectionOrSize: UILabel!
    @IBOutlet var weightOrVolume: UILabel!
    @IBOutlet var addToCartButton: UIButton!
    @IBOutlet var addSuccessfully: UILabel!
    
    @IBOutlet var brand2: UILabel!
    @IBOutlet var productSection: UILabel!
    @IBOutlet var littleInfo: UILabel!
    @IBOutlet var rateAsRatio: UILabel!
    @IBOutlet var rateAsNumber: UILabel!
    @IBOutlet var rate2: CosmosView!
    @IBOutlet var fav: UIBarButtonItem!
    @IBOutlet var CartProductNumber: UILabel!
    @IBOutlet var CartTotalCost: UILabel!
    @IBOutlet var CartIconView: UIView!
    
    var isFav = false
    var productId = 0
    var product: productDetails?
    var favProducts = [productData]()
    let informationTitlesEggEn = ["category","color","volume","size"]
    let informationTitlesEggAr = ["المقاس","الحجم","اللون","القسم"]
    let informationTitlesChickenAr = ["الوزن","الفئة","النوع","القسم"]
    var rowInCart: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViews()
        setupBackButtonWithPOP(false)
        getProductDetails()
    }
    fileprivate func getRow(){
        rowInCart = AppDelegate.CartItems.firstIndex(where: {$0.id == productId})
        addSuccessfully.isHidden = rowInCart == nil
        if rowInCart != nil{
            addProductButtonDesign(addToCartButton)
        }else{
            removeProductButtonDesign(addToCartButton)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getRow()
        updateCartItems(CartProductNumber,CartTotalCost, CartIconView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    fileprivate func informationTitles(){
        if product?.weightName != nil{
            if AppDelegate.lang != "en"{
                category.text = informationTitlesChickenAr[3]
                typeOrColor.text = informationTitlesChickenAr[2]
                sectionOrSize.text = informationTitlesChickenAr[1]
                weightOrVolume.text = informationTitlesChickenAr[0]
            }
        }else{
            let english = AppDelegate.lang == "en"
            category.text = english ?
                informationTitlesEggEn[0] : informationTitlesEggAr[3]
            typeOrColor.text = english ?
                informationTitlesEggEn[1] : informationTitlesEggAr[2]
            sectionOrSize.text = english ? informationTitlesEggEn[2] : informationTitlesEggAr[1]
            weightOrVolume.text = english ? informationTitlesEggEn[3] : informationTitlesEggAr[0]
        }
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
        productSection.text = product?.catName ?? ""
        
        categoryValue.text = product?.catName ?? ""
        weightOrVolumeValue.testValues(product?.weightName, product?.volumeName)
        sectionOrSizeValue.testValues(product?.sizeName, product?.sectionName)
        typeOrColorValue.testValues(product?.typeName, product?.sectionName)
        
        littleInfo.testValues(product?.sizeName, "\(product?.typeName ?? "") - \(product?.weightName ?? "")")
        fav.image = (isFav ? #imageLiteral(resourceName: "ic_ac_fav_active") : #imageLiteral(resourceName: "ic_ac_fav")).withRenderingMode(.alwaysOriginal)
        informationTitles()
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
    
    fileprivate func setupHorizontalScrollView(){
        if horizontalScrollView != nil{
            horizontalScrollView.removeFromSuperview()
        }
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
    fileprivate func addProductButtonDesign(_ sender: UIButton) {
        sender.setTitle(AppDelegate.lang == "en" ? "cancel" : "إلغاء", for: .normal)
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = .gray
        sender.setImage(nil, for: .normal)
    }
    fileprivate func removeProductButtonDesign(_ sender: UIButton) {
        sender.setTitle(AppDelegate.lang == "en" ? "add to cart" : "أضف الى السلة", for: .normal)
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = UIColor(named: "green")
        sender.setImage(#imageLiteral(resourceName: "ic_add_cart"), for: .normal)
    }
    @IBAction func addProductToCart(sender: UIButton){
        if rowInCart == nil{
            if AppDelegate.CartBranch == nil{
                showBranches()
            }else{
                let count = self.product?.branches?.first(where: { $0.id == AppDelegate.CartBranch
                })?.quantity
                
                if addProductToCart(item: productData(id: product?.id, title: product?.title, catID: "0", catName: product?.catName, sectionName: product?.sectionName, volumeName: product?.volumeName, sizeName: product?.sizeName, price: product?.price, rate: product?.rate, image: product?.images![0].image, typeName: product?.typeName, weightName: product?.weightName), brand: (product?.brand ?? ""),sellerId: product?.sellerID ?? 0,branchItems:count ?? 0){
                    getRow()
                    updateCartItems(CartProductNumber,CartTotalCost, CartIconView)
                }
            }
            
        }else{
            guard let rowInCart = rowInCart else{
                return
            }
            _ = AppDelegate.CartItems.remove(at: rowInCart)
            updateCartItems(CartProductNumber,CartTotalCost, CartIconView)
            getRow()
        }
    }
    @IBAction func completeOrder() {
        if AppDelegate.CartItems.count > 0{
            OpenCartNavigations(NavigationName: "cart")
        }
    }
    
    func showBranches(){
        let loginVC = branchesAlert(nibName: "branchesAlert", bundle: nil)
        loginVC.sellerId = product?.sellerID ?? 0
        let popup = PopupDialog(viewController: loginVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: false,
                                panGestureDismissal: false)
        present(popup, animated: true, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 220, height: 388)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "products", for: indexPath) as! productCell
        if let data = product?.sellerProducts?[indexPath.row]{
            cell.link = self
            cell.setupCellData(data: data)
            cell.addToCart.tag = indexPath.row
            cell.addToCart.addTarget(self, action: #selector(toCart), for: .touchUpInside)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 12, bottom: 12, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        productId = product?.sellerProducts?[indexPath.row].id ?? 0
        getProductDetails()
    }
    @objc func toCart(sender: UIButton){
        product?.sellerProducts?[sender.tag].catName = product?.catName
        if addProductToCart(item: (product?.sellerProducts?[sender.tag])!, brand: product?.brand ?? "",sellerId: product?.sellerID ?? 0, branchItems: 0){
            sender.backgroundColor = .gray
            updateCartItems(CartProductNumber,CartTotalCost, CartIconView)
        }
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
extension UILabel{
    func testValues(_ a: String?,_ b: String?){
        self.text = a != nil ? a ?? "" : b ?? ""
    }
}
