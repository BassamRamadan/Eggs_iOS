//
//  productDetailsJson.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/23/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

class productDetailsJson: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: productDetails?
    
    init(status: Bool?, code: Int?, message: String?, data: productDetails?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class productDetails: Codable {
    let id: Int?
    let title, catName, sectionName, volumeName: String?
    let sizeName, price: String?
    let rate: Int?
    let code, note, taxes, brand: String?
    let brandImage: String?
    let images: [Image]?
    let branches: [Branch]?
    let seller: String?
    let sellerID: Int?
    let sellerType: String?
    let sellerProducts: [productData]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case catName = "cat_name"
        case sectionName = "section_name"
        case volumeName = "volume_name"
        case sizeName = "size_name"
        case price, rate, code, note, taxes, brand
        case brandImage = "brand_image"
        case images, branches, seller
        case sellerID = "seller_id"
        case sellerType = "seller_type"
        case sellerProducts = "seller_products"
    }
    
    init(id: Int?, title: String?, catName: String?, sectionName: String?, volumeName: String?, sizeName: String?, price: String?, rate: Int?, code: String?, note: String?, taxes: String?, brand: String?, brandImage: String?, images: [Image]?, branches: [Branch]?, seller: String?, sellerID: Int?, sellerType: String?, sellerProducts: [productData]?) {
        self.id = id
        self.title = title
        self.catName = catName
        self.sectionName = sectionName
        self.volumeName = volumeName
        self.sizeName = sizeName
        self.price = price
        self.rate = rate
        self.code = code
        self.note = note
        self.taxes = taxes
        self.brand = brand
        self.brandImage = brandImage
        self.images = images
        self.branches = branches
        self.seller = seller
        self.sellerID = sellerID
        self.sellerType = sellerType
        self.sellerProducts = sellerProducts
    }
}

// MARK: - Branch
class Branch: Codable {
    let title: String?
    let id, quantity: Int?
    
    init(title: String?, id: Int?, quantity: Int?) {
        self.title = title
        self.id = id
        self.quantity = quantity
    }
}

// MARK: - Image
class Image: Codable {
    let id: Int?
    let image: String?
    
    init(id: Int?, image: String?) {
        self.id = id
        self.image = image
    }
}

// MARK: - SellerProduct
class SellerProduct: Codable {
    let id: Int?
    let title: String?
    let rate: Int?
    let price: String?
    let image: String?
    let typeName, sectionName, weightName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, rate, price, image
        case typeName = "type_name"
        case sectionName = "section_name"
        case weightName = "weight_name"
    }
    
    init(id: Int?, title: String?, rate: Int?, price: String?, image: String?, typeName: String?, sectionName: String?, weightName: String?) {
        self.id = id
        self.title = title
        self.rate = rate
        self.price = price
        self.image = image
        self.typeName = typeName
        self.sectionName = sectionName
        self.weightName = weightName
    }
}
