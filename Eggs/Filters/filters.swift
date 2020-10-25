//
//  filters.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import MARKRangeSlider
class filters: common{
    @IBOutlet var filtersCollection: UICollectionView!
    
    @IBOutlet weak var priceSilder: MARKRangeSlider!
    @IBOutlet weak var price: UILabel!
    
    
    var parentId = 1
    var isEggs: Bool = false
    var eggsEn = ["the type","the size","the Package size"]
    var checkenEn = ["","the class","the weight"]
    var eggsPerSection = [3,3,2]
    var checkenPerSection = [2,2,3]
    var filtersArr = [String:[filtersData]]()
    var idsSelected = [0,0,0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupSilder()
       setUpCollection()
       setupBackButtonWithPOP(false)
    }
    
    
    fileprivate func setupSilder(){
        priceSilder.addTarget(self, action: #selector(rangeSliderValueDidChange), for: .valueChanged)
        priceSilder.setMinValue(1, maxValue: 100)
        priceSilder.setLeftValue(3, rightValue: 50)
        priceSilder.minimumDistance = 1
    }
    func recursion(parentId: Int, level: Int){
        if level > 4{
            return
        }
        getFiltersData(sectionName: self.eggsEn[level-2], parentId: parentId, level: level){
            (ok) in
                self.idsSelected[level-2] = self.filtersArr[self.eggsEn[level-2]]?.first?.id ?? 0
            self.recursion(parentId: self.idsSelected[level-2], level: level+1)
        }
    }
    fileprivate func setUpCollection(){
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        recursion(parentId: parentId, level: 2)
    }
    @objc func rangeSliderValueDidChange(slider: MARKRangeSlider){
        price.text = "from \(Int(slider.leftValue)) - to \(Int(slider.rightValue))"
    }
    
}

extension filters: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        let data = filtersArr[eggsEn[section]]
        return data?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let byRow = eggsPerSection[indexPath.section]
        return CGSize(width: (collectionView.frame.width-(CGFloat(byRow)*2.5))/CGFloat(byRow), height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.sectionHeaderlabel.text = eggsEn[indexPath.section]
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filters", for: indexPath) as! filterCell
        let data = filtersArr[eggsEn[indexPath.section]]
        if  (idsSelected.firstIndex(of: data?[indexPath.row].id ?? 0) != nil){
             cell.check.imageView?.image = #imageLiteral(resourceName: "ic_check_box_checked")
        }else{
             cell.check.imageView?.image = #imageLiteral(resourceName: "ic_check_box")
        }
        cell.name.text = data?[indexPath.row].title ?? ""
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let data = self.filtersArr[self.eggsEn[indexPath.section]]
        let id = data?[indexPath.row].id ?? 0
        self.idsSelected[indexPath.section] = id
        
        if indexPath.section == 2{
            filtersCollection.reloadSections(.init(integer: 2))
        }else{
            self.recursion(parentId: id, level: indexPath.section+3)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.5
    }
    
}

extension filters{
    fileprivate func getFiltersData(sectionName: String, parentId: Int, level: Int, completion: @escaping(Bool) -> Void) {
        self.loading()
        let url = AppDelegate.LocalUrl + "merchant/products/categories/\(isEggs == true ? 2 : 1)?parent_id=\(parentId)&level=\(level)"
        let headers = [
            "Content-Type": "application/json" ,
            "Accept" : "application/json",
            "Authorization": (CashedData.getUserApiKey() ?? ""),
            "lang": "en",
            "country_id": "187"
        ]
        AlamofireRequests.getMethod(url: url, headers: headers){
            (error, success, jsonData) in
            do {
                let decoder = JSONDecoder()
                if error == nil {
                    if success {
                        
                        let dataRecived = try decoder.decode(filtersJson.self, from: jsonData)
                        self.filtersArr[sectionName] = []
                        self.filtersArr[sectionName]?.append(contentsOf: dataRecived.data ?? [])
                        self.filtersCollection.reloadData()
                        completion(true)
                        self.stopAnimating()
                    }else{
                        let dataRecived = try   decoder.decode(ErrorHandle.self, from: jsonData)
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
