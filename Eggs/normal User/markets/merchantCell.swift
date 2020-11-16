//
//  marketCell.swift
//  Eggs
//
//  Created by Bassam Ramadan on 11/2/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit
import Cosmos
class marketCell: UICollectionViewCell{
    @IBOutlet var title: UILabel!
    @IBOutlet var note: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var rate: CosmosView!
    @IBOutlet var ratio: UILabel!
    @IBOutlet var fav:  UIButton!
}
