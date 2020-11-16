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
    
    func setupCellData(data: productData,isFav: Bool){
        image.sd_setImage(with: URL(string: data.image ?? ""))
        title.text = data.title ?? ""
        salary.text = data.price ?? "0"
        rate.rating = Double(data.rate ?? 0)
        users.text = "\(Int((rate.rating/5.0)*100))%"
        fav.setImage((isFav == true ? #imageLiteral(resourceName: "ic_ac_fav_active"):#imageLiteral(resourceName: "ic_ac_fav")).withRenderingMode(.alwaysOriginal), for: .normal)
    }
}
