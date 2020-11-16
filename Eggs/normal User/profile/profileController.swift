//
//  profileController.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/3/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class profileController: common{
    @IBOutlet var currentName : UILabel!
    @IBOutlet var currentEmail : UILabel!
    @IBOutlet var currentImage : UIImageView!
    
    @IBOutlet var name : UITextField!
    @IBOutlet var email : UITextField!
    @IBOutlet var pass : UITextField!
    @IBOutlet var configPass : UITextField!
    
    @IBOutlet var nameSeperator : UIView!
    @IBOutlet var emailSeperator : UIView!
    @IBOutlet var passSeperator : UIView!
    @IBOutlet var configSeperator : UIView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupUserData()
    }
    fileprivate func setupUserData(){
        name.delegate = self
        email.delegate = self
        pass.delegate = self
        configPass.delegate = self
        currentName.text = CashedData.getUserName() ?? ""
        currentEmail.text = CashedData.getUserEmail() ?? ""
        
        currentImage.sd_setImage(with: URL(string: CashedData.getUserImage()
            ?? ""))
        if currentImage.image == nil{
            currentImage.image = #imageLiteral(resourceName: "user_default_avatar")
        }
    }
    @IBAction func showPass(sender: UIButton){
        if sender.tag == 1{
            pass.isSecureTextEntry = !(pass.isSecureTextEntry)
        }else{
            configPass.isSecureTextEntry = !(configPass.isSecureTextEntry)
        }
    }
    
}
extension profileController: UITextFieldDelegate{
    
    func switchSeperator(){
        nameSeperator.backgroundColor = UIColor(named: "gray")
        emailSeperator.backgroundColor = UIColor(named: "gray")
        passSeperator.backgroundColor = UIColor(named: "gray")
        configSeperator.backgroundColor = UIColor(named: "gray")
        name.textColor = .darkText
        email.textColor = .darkText
        pass.textColor = .darkText
        configPass.textColor = .darkText
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switchSeperator()
        switch textField {
        case name:
            nameSeperator.backgroundColor = UIColor(named: "blue")
        case email:
            emailSeperator.backgroundColor = UIColor(named: "blue")
        case pass:
            passSeperator.backgroundColor = UIColor(named: "blue")
        default:
            configSeperator.backgroundColor = UIColor(named: "blue")
        }
        textField.textColor = UIColor(named: "blue")
        return true
    }
}
