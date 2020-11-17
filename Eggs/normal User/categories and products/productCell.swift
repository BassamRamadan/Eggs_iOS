//
//  productCell.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
class productCell: UICollectionViewCell {
    @IBOutlet var title: UILabel!
    @IBOutlet var users: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var salary: UILabel!
    @IBOutlet var coin: UILabel!
    @IBOutlet var rate: CosmosView!
    @IBOutlet var image: UIImageView!
    @IBOutlet var fav: UIButton!
    @IBOutlet var addToCart: UIButton!
    var link: common?
    
    func setupCellData(data: productData,isFav: Bool){
        image.sd_setImage(with: URL(string: data.image ?? ""))
        title.text = data.title ?? ""
        salary.text = data.price ?? "0"
        rate.rating = Double(data.rate ?? 0)
        users.text = "\(Int((rate.rating/5.0)*100))%"
        fav.tag = data.id ?? 0
        fav.setImage((isFav == true ? #imageLiteral(resourceName: "ic_ac_fav_active"):#imageLiteral(resourceName: "ic_ac_fav")).withRenderingMode(.alwaysOriginal), for: .normal)
        fav.addTarget(self, action: #selector(FavAction), for: .touchUpInside)
    }
    fileprivate func callBackToViewController(ok: Bool) {
        if ((self.link as? mainController) != nil){
            (self.link as? mainController)?.someMethodsWantToCall(cell: self, isFav: ok)
        }else if ((self.link as? productDetailsController) != nil){
            (self.link as? productDetailsController)?.someMethodsWantToCall(cell: self, isFav: ok)
        }else if ((self.link as? marketProfile) != nil){
            (self.link as? marketProfile)?.someMethodsWantToCall(cell: self, isFav: ok)
        }
    }
    
    @objc func FavAction(){
        if fav.currentImage?.pngData() == #imageLiteral(resourceName: "ic_ac_fav").pngData(){
            ToFav(productId: fav.tag){
                data in self.callBackToViewController(ok: true)}
        }else{
            outFav(productId: fav.tag){
                data in self.callBackToViewController(ok: false)}
        }
    }
    func ToFav(productId: Int, completion: @escaping (Bool) -> Void){
        link?.loading()
        let url = AppDelegate.LocalUrl + "product/addFav/product"
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
                        completion(true)
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                        self.link?.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    }
                    self.link?.stopAnimating()
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                    self.link?.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                    self.link?.stopAnimating()
                }
            }catch {
                self.link?.present(common.makeAlert(), animated: true, completion: nil)
                self.link?.stopAnimating()
            }
        }
    }
    func outFav(productId: Int,completion: @escaping (Bool) -> Void){
        self.link?.loading()
        let url = AppDelegate.LocalUrl + "product/deleteFav/product/\(productId)"
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
                        self.link?.stopAnimating()
                    }else{
                        let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                         self.link?.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                         self.link?.stopAnimating()
                    }
                    
                }else{
                    let dataRecived = try decoder.decode(ErrorHandle.self, from: jsonData)
                     self.link?.present(common.makeAlert(message: dataRecived.message ?? ""), animated: true, completion: nil)
                     self.link?.stopAnimating()
                }
            }catch {
                 self.link?.present(common.makeAlert(), animated: true, completion: nil)
                 self.link?.stopAnimating()
            }
        }
    }
}
