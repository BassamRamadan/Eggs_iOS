//
//  AppDelegate.swift
//  perfume
//
//  Created by Bassam Ramadan on 4/15/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var isEnglish = true
    static var stringWithLink = ""
    static var LocalUrl = "https://www.eggs-apps.com/app/api/"
    static var badge = [CAShapeLayer()]
    static var firstBadge = [true]
    static var CartProducts = [CartProduct]()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        IQKeyboardManager.shared.enable = true
    //    GMSServices.provideAPIKey("AIzaSyCH41pwRsQKTf9IXYWxzbMA1V6cHHsmmZM")
   // GMSPlacesClient.provideAPIKey("AIzaSyCH41pwRsQKTf9IXYWxzbMA1V6cHHsmmZM")
    //    FirebaseApp.configure()
        CashedData.saveUserApiKey(token: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjUsImlzcyI6Imh0dHA6Ly9lZ2cubWUvYXBpL3VzZXJzL2F1dGgiLCJpYXQiOjE1OTgzNzA3MjIsImV4cCI6MTYwODg4MjcyMiwibmJmIjoxNTk4MzcwNzIyLCJqdGkiOiJZeDNieThCOE1URThWZ0huIn0.1KpTH8v6rtwP5yzJJcS9b_szfkBCYKy5qTziWJP_TMI")
        
        setupCartProducts()
        return true
    }

    func setupCartProducts(){
        if let decoded  = UserDefaults.standard.object(forKey: "FullCartData") as? Data{
            AppDelegate.CartProducts = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [CartProduct]
        }else{
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: [CartProduct]())
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "FullCartData")
            if let decoded  = UserDefaults.standard.object(forKey: "FullCartData") as? Data{
                AppDelegate.CartProducts = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [CartProduct]
            }
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

