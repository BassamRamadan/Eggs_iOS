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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filtersCollection.delegate = self
        filtersCollection.dataSource = self
        
        priceSilder.addTarget(self, action: #selector(rangeSliderValueDidChange), for: .valueChanged)
        priceSilder.setMinValue(1, maxValue: 100)
        priceSilder.setLeftValue(3, rightValue: 50)
        priceSilder.minimumDistance = 1
    }
    @objc func rangeSliderValueDidChange(slider: MARKRangeSlider){
        price.text = "from \(Int(slider.leftValue)) - to \(Int(slider.rightValue))"
    }
}

extension filters: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let byRow = indexPath.section + 1
        return CGSize(width: (collectionView.frame.width-(CGFloat(byRow)*10.0))/CGFloat(byRow), height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader{
            sectionHeader.sectionHeaderlabel.text = "Section \(indexPath.section)"
            return sectionHeader
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filters", for: indexPath)
        return cell
    }
    
    
}
