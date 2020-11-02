//
//  markets.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/2/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class markets: common{
    @IBOutlet var marketsCollection: UICollectionView!
    var marketsData: categoriesData?
    var favMarkets = [categoryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        marketsCollection.delegate = self
        marketsCollection.dataSource = self
        getMarkets()
    }
    func getMyFav(){
        getFavProducts(markets: "Market"){
            data,newFavMarkets  in
            self.favMarkets.removeAll()
            self.favMarkets.append(contentsOf: newFavMarkets)
            self.marketsCollection.reloadData()
        }
    }
    @IBAction func addMarketTo_MyFav(sender: UIButton){
        let indx: Any? = favMarkets.firstIndex(where: {$0.id == marketsData?.categoryItems?[sender.tag].id ?? 0})
        if indx == nil{
                addToFav(productId: marketsData?.categoryItems?[sender.tag].id ?? 0, product: false){
                ok in
                sender.setImage(#imageLiteral(resourceName: "ic_fav_active").withRenderingMode(.alwaysOriginal), for: .normal)
                self.favMarkets.append((self.marketsData?.categoryItems?[sender.tag])!)
            }
        }else{
            removeProductFromFav(product: false, productId: marketsData?.categoryItems?[sender.tag].id ?? 0){
                ok in
                sender.setImage(#imageLiteral(resourceName: "ic_fav").withRenderingMode(.alwaysOriginal), for: .normal)
                self.favMarkets.remove(at: indx as! Int)
            }
        }
    }
}
extension markets: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return marketsData?.categoryItems?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return .init(width: collectionView.frame.width, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketsCell", for: indexPath) as! marketCell
        if let dataCell = marketsData?.categoryItems?[indexPath.row]{
            cell.title.text = dataCell.name ?? ""
            cell.note.text = dataCell.note ?? ""
            cell.image.sd_setImage(with: URL(string: dataCell.image ?? ""))
            cell.rate.rating = Double(dataCell.rate ?? 0)
            cell.ratio.text = "\(Int((cell.rate.rating/5.0)*100))%"
            
            if favMarkets.firstIndex(where: {$0.id == dataCell.id}) != nil{
                cell.fav.setImage(#imageLiteral(resourceName: "ic_ac_fav_active").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.fav.setImage(#imageLiteral(resourceName: "ic_ac_fav").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
extension markets {
    fileprivate func getMarkets() {
        self.loading()
        let url = AppDelegate.LocalUrl + "product/markets"
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
                        self.marketsData = dataRecived.data
                        self.marketsCollection.reloadData()
                        self.getMyFav()
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
