//
//  mainController.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/8/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class mainController: common {

    @IBOutlet var mainCollection: UICollectionView!
    @IBOutlet var detailsCollection: UICollectionView!
    
    @IBOutlet var categoriesView: UIView!
    @IBOutlet var productsView: UIView!
    
    var data: categoryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesView.isHidden = false
        productsView.isHidden = true
        collectionViewaDelegation()
        getCategory()
    }
    
    fileprivate func collectionViewaDelegation() {
        mainCollection.delegate = self
        mainCollection.dataSource = self
        detailsCollection.delegate = self
        detailsCollection.dataSource = self
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
                        self.data = dataRecived.data
                        self.mainCollection.reloadData()
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
        if collectionView == mainCollection{
            return data?.categoryItems?.count ?? 0
        }else{
            return 3
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == mainCollection{
            return .init(width: collectionView.frame.width, height: 150)
        }else{
            return .init(width: (collectionView.frame.width - 10)/2, height: 310)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main", for: indexPath) as! categoryCell
            if let dataCell = data?.categoryItems?[indexPath.row]{
                cell.title.text = dataCell.title ?? ""
                cell.note.text = dataCell.note ?? ""
                cell.image.sd_setImage(with: URL(string: dataCell.image ?? ""))
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "details", for: indexPath)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        categoriesView.isHidden = true
        productsView.isHidden = false
        detailsCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == mainCollection{
            return 0
        }else{
            return 15
        }
    }
}
