//
//  cart.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/14/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import UIKit

class cart: common{
    @IBOutlet var cartCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cartCollection.delegate = self
        cartCollection.dataSource = self
    }
}
extension cart: UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cart", for: indexPath)
        
        
        return cell
    }
    
    
}
