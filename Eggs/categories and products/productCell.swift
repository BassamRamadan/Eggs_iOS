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
}
