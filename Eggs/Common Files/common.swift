//
//  common.swift
//  Tourist-Guide
//
//  Created by mac on 11/28/19.
//  Copyright © 2019 Tamkeen. All rights reserved.
//
import UIKit
import NVActivityIndicatorView
import SDWebImage
import PopupDialog
class common : UIViewController , NVActivityIndicatorViewable{
    
    class func drowbackButton()->UIButton {
        let notifBtn: UIButton = UIButton(type: UIButton.ButtonType.custom)
        notifBtn.setImage(#imageLiteral(resourceName: "ic_back_dark"), for: [])
        notifBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        return notifBtn
        // Do any additional setup after loading the view
    }
    
    
    func openSetting(pagTitle:String){
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: pagTitle) as! UINavigationController
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    func openRegisteringPage(pagTitle:String,window: Bool = false){
        let storyboard = UIStoryboard(name: "Registeration", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: pagTitle) as! UINavigationController
        if window{
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = linkingVC
        }else{
            linkingVC.modalPresentationStyle = .fullScreen
            self.present(linkingVC,animated: true,completion: nil)
        }
    }
    func noDataAvailable(_ collectionView: UICollectionView){
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        noDataLabel.text = AppDelegate.lang == "en" ? "There are no products added currently." : "لا يوجد منتجات مضافة حاليا"
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        collectionView.backgroundView = noDataLabel
    }
    func openMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Main") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = linkingVC
    }
 
    func AdminLogout(currentController: UIViewController){
            CashedData.saveUserApiKey(token: "")
            openMain()
    }
    
    func loading(_ message:String = ""){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "", type: NVActivityIndicatorType.lineSpinFadeLoader)
    }
    
    class func makeAlert( message: String = "عفوا حدث خطأ في الاتصال من فضلك حاول مره آخري") -> UIAlertController {
        let alert = UIAlertController(title: "تنبيه", message: message , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default,.cancel,.destructive:
                print("default")
            @unknown default:
                print("default")
            }}))
        return alert
    }
    func CallPhone(phone: String) {
        var fullMob: String = phone
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        if fullMob != "" {
            let url = NSURL(string: "tel://\(fullMob)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    func callWhats(whats: String) {
        var fullMob: String = whats
        fullMob = fullMob.replacingOccurrences(of: " ", with: "")
        fullMob = fullMob.replacingOccurrences(of: "+", with: "")
        fullMob = fullMob.replacingOccurrences(of: "-", with: "")
        let urlWhats = "whatsapp://send?phone=\(fullMob)"
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                    })
                } else {
                    self.present(common.makeAlert(message:NSLocalizedString("WhatsApp Not Found on your device", comment: "")), animated: true, completion: nil)
                }
            }
        }
    }
    
    func setupBackButtonWithPOP(_ pop:Bool? = true) {
        self.navigationItem.hidesBackButton = true
        let backBtn: UIButton = common.drowbackButton()
        let backButton = UIBarButtonItem(customView: backBtn)
        if pop == true{
            backBtn.addTarget(self, action: #selector(self.POP), for: UIControl.Event.touchUpInside)
        }else{
            backBtn.addTarget(self, action: #selector(self.Dismiss), for: UIControl.Event.touchUpInside)
        }
        
        if AppDelegate.lang == "en"{
            self.navigationItem.setLeftBarButton(backButton, animated: true)
        }else{
            self.navigationItem.setRightBarButton(backButton, animated: true)
        }
    }
    
    @objc func Dismiss() {
        self.navigationController?.dismiss(animated: true)
    }
   
    @objc func POP() {
        self.navigationController?.popViewController(animated: true)
    }
    func addProductToCart(item: productData,brand: String,sellerId: Int,branchItems: Int) -> Bool{
        let info = item.weightName == nil ? "\(item.sizeName ?? "") - \(item.sectionName ?? "") - \(item.volumeName ?? "")" : "\(item.typeName ?? "") - \(item.weightName ?? "")"
        let cartItem = CartItem(id: item.id, title: item.title, catName: item.catName, price: item.price, image: item.image, count: 1, info: info, brand: brand,sellerId: sellerId,branchId: AppDelegate.CartBranch,branchItems: branchItems)
        if AppDelegate.CartItems.count > 0{
            if AppDelegate.CartItems[0].sellerId != sellerId {
                self.present(common.makeAlert(message: AppDelegate.lang == "en" ? "should select products for the same seller in cart" : "يجب اختيار منتجات لنفس البائع الموجود بالعربة"), animated: true, completion: nil)
                return false
            }
        }
        AppDelegate.CartItems.append(cartItem)
        return true
    }
    func updateCartItems(_ CartProductNumber: UILabel,_ CartTotalCost: UILabel,_ CartIconView: UIView){
        CartProductNumber.text = "\(AppDelegate.CartItems.count)"
        CartProductNumber.isHidden = AppDelegate.CartItems.isEmpty
        CartTotalCost.text = AppDelegate.calculateCosts()
        CartIconView.isHidden = AppDelegate.CartItems.isEmpty
    }
    
    class func OpenSetting(){
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "Setting")
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = linkingVC
    }
    func OpenCartNavigations(NavigationName: String) {
        let storyboard = UIStoryboard(name: "cart", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: NavigationName) as!
        UINavigationController
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC,animated: true,completion: nil)
    }
    func openProductDetails(productId : Int){
        let storyboard = UIStoryboard(name: "productDetails", bundle: nil)
        let linkingVC = storyboard.instantiateViewController(withIdentifier: "productDetails")  as! UINavigationController
        let VC = linkingVC.viewControllers[0] as! productDetailsController
        VC.productId = productId
        linkingVC.modalPresentationStyle = .fullScreen
        self.present(linkingVC, animated: true)
    }
    
    
    
    func getPriceAfterDiscount(price: String,discount: String) -> String{
        var IntPrice:Double? = Double(price)
        var IntDiscount:Double? = Double(discount)
        
        IntDiscount = (IntDiscount ?? 0.0)/100.0
        if let p = IntDiscount{
            IntPrice = (IntPrice ?? 0.0) - ((IntPrice ?? 0.0) * p)
        }
        return "\(IntPrice ?? 0.0)"
    }
    
    
    
   
}
 extension common{
    
    func addToFav(productId: Int,product: Bool, completion: @escaping (Bool) -> Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "product/addFav/\(product == true ? "product":"market")"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "lang": "en",
            "country_id": "187",
            "Authorization": (CashedData.getUserApiKey() ?? "")
        ]
        let info = [
            "id": productId
        ]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        self.present(common.makeAlert(message: "تم الإضافة بنجاح"), animated: true, completion: nil)
                        completion(true)
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
    
    func removeProductFromFav(product: Bool,productId: Int,completion: @escaping (Bool) -> Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "product/deleteFav/\(product == true ? "product":"market")/\(productId)"
        let headers = [
            "lang": "en",
            "country_id": "187",
            "Authorization": (CashedData.getUserApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        
                        completion(true)
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
    func getFavProducts(markets: String? = "",completion: @escaping ([productData],[categoryData]) -> Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "product/getFav\(markets ?? "")"
        let headers = [
            "lang": "en",
            "country_id": "187",
            "Authorization": (CashedData.getUserApiKey() ?? "")
        ]
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        if markets == ""{
                            let dataRecived = try decoder.decode(productsJson.self, from: jsonData)
                            
                            completion(dataRecived.data?.data ?? [], [])
                        }else{
                            let dataRecived = try decoder.decode(categoryJson.self, from: jsonData)
                            
                            completion([],dataRecived.data?.categoryItems ?? [])
                        }
                        
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
    
    func getProducts(url: String,completion: @escaping (productsData) -> Void) {
        self.loading()
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
                        let dataRecived = try decoder.decode(productsJson.self, from: jsonData)
                        completion(dataRecived.data!)
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
    func addRate(productId: Int,rate: Double,isProduct: Bool, completion: @escaping (Bool) -> Void){
        self.loading()
        let url = AppDelegate.LocalUrl + "product/\(isProduct == true ? "rateProduct":"rateMarket")"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "lang": "en",
            "country_id": "187",
            "Authorization": (CashedData.getUserApiKey() ?? "")
        ]
        let info = [
            "id": productId,
            "rate": rate
            ] as [String : Any]
        AlamofireRequests.PostMethod(methodType: "POST", url: url, info: info, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    if dataRecived.status == true{
                        completion(true)
                    }
                    self.stopAnimating()
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
    
    func getBranches(id: Int,completion: @escaping ([branchData]) -> Void) {
        self.loading()
        let url = AppDelegate.LocalUrl + "product/getBranches/\(id)"
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
                        let dataRecived = try decoder.decode(branchesModel.self, from: jsonData)
                        completion(dataRecived.data ?? [])
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



extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
}
extension UIImageView {
    func setDefaultImage(url: String){
        self.sd_setImage(with: URL(string: url))
        if self.image == nil{
            self.image =  #imageLiteral(resourceName: "ic_upload_defult_img")
        }
    }
}
public extension CATransaction {
    static func perform(method: () -> Void, completion: @escaping () -> Void) {
        begin()
        setCompletionBlock {
            completion()
        }
        method()
        commit()
    }
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor,stokColor:UIColor) {
        fillColor = color.cgColor
        strokeColor = stokColor.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2 + 5, height: radius * 2+5))).cgPath
    }
}
extension UIButton{
    public func addBadge(id:Int,number: Int, withOffset offset: CGPoint = CGPoint.zero, andBackgroundColor color: UIColor, strokeColor: UIColor,textColor:UIColor) {
        
        guard let view = self as? UIView
            else { return }
        
        // Initialize Badge
        if number == 0{
            AppDelegate.badge[id].removeFromSuperlayer()
            AppDelegate.badge[id] = CAShapeLayer()
            AppDelegate.firstBadge[id] = true
            return
        }
       
        if AppDelegate.firstBadge[id]{
            let radius = CGFloat(8)
            let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
            AppDelegate.badge[id].drawCircleAtLocation(location: location, withRadius: radius, andColor: color, stokColor: strokeColor)
            view.layer.addSublayer(AppDelegate.badge[id])
            
            // Initialiaze Badge's label
            let label = CATextLayer()
            label.string = "\(number)"
            label.alignmentMode = CATextLayerAlignmentMode.center
            if number > 9 {
                label.fontSize = 11
                label.font = UIFont(name:"HelveticaNeue-Bold", size: 11)!
                label.frame = CGRect(origin: CGPoint(x: location.x-5, y: offset.y+4), size: CGSize(width: 12, height: 16))
            }else{
                label.fontSize = 11
                label.font = UIFont(name:"HelveticaNeue-Bold", size: 11)!
                label.frame = CGRect(origin: CGPoint(x: location.x - 2, y: offset.y+4), size: CGSize(width: 10, height: 16))
            }
            label.foregroundColor = textColor.cgColor
            label.backgroundColor = UIColor.clear.cgColor
            label.contentsScale = UIScreen.main.scale
            AppDelegate.badge[id].addSublayer(label)
            var handle: UInt8 = 0
            // Save Badge as UIBarButtonItem property
            objc_setAssociatedObject(self, &handle, AppDelegate.badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            AppDelegate.firstBadge[id] = false
        }else{
            (AppDelegate.badge[id].sublayers?[0] as! CATextLayer).string = "\(number)"
        }
    }
    
}
class SubclassedUIButton: UIButton {
    var typeCell: String?
    var indexPath: IndexPath?
    var isFav: Bool?
}
