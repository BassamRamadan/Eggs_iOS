//
//  setting.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/2/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class setting: common {
    
    @IBOutlet var totalOrders : UILabel!
    @IBOutlet var acceptedOrders : UILabel!
    @IBOutlet var refusedOrders : UILabel!
    @IBOutlet var currentName : UILabel!
    @IBOutlet var currentEmail : UILabel!
    @IBOutlet var currentImage : UIImageView!
  
    var userData: profileData?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfile()
    }
    fileprivate func setupUserData(){
        totalOrders.text = "\(userData?.totalOrders ?? 0)"
        acceptedOrders.text = "\(userData?.acceptedOrders ?? 0)"
        refusedOrders.text = "\(userData?.refusedOrders ?? 0)"
        currentName.text = userData?.username ?? ""
        currentEmail.text = userData?.email ?? ""
        
        currentImage.sd_setImage(with: URL(string: userData?.avatar
            ?? ""))
        if currentImage.image == nil{
            currentImage.image = #imageLiteral(resourceName: "user_default_avatar")
        }
    }
    func getProfile(){
        loading()
        let url = AppDelegate.LocalUrl + "users/profile"
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
                        let dataRecived = try decoder.decode(profileJson.self, from: jsonData)
                        self.userData = dataRecived.data
                        self.setupUserData()
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
