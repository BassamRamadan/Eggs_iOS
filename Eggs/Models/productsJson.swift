//
//  productsJson.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/20/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

class productsJson: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: productsData?
    
    init(status: Bool?, code: Int?, message: String?, data: productsData?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class productsData: Codable {
    let countTotal: Int?
    let nextPageURL: String?
    let pages: Int?
    let data: [productData]?
    
    enum CodingKeys: String, CodingKey {
        case countTotal = "count_total"
        case nextPageURL = "nextPageUrl"
        case pages, data
    }
    
    init(countTotal: Int?, nextPageURL: String?, pages: Int?, data: [productData]?) {
        self.countTotal = countTotal
        self.nextPageURL = nextPageURL
        self.pages = pages
        self.data = data
    }
}

// MARK: - Datum
class productData: Codable {
    let id: Int?
    let title, catID, catName, sectionName: String?
    let volumeName, sizeName, price: String?
    let rate: Int?
    let image: String?
    let typeName, weightName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case catID = "cat_id"
        case catName = "cat_name"
        case sectionName = "section_name"
        case volumeName = "volume_name"
        case sizeName = "size_name"
        case price, rate, image
        case typeName = "type_name"
        case weightName = "weight_name"
    }
    
    init(id: Int?, title: String?, catID: String?, catName: String?, sectionName: String?, volumeName: String?, sizeName: String?, price: String?, rate: Int?, image: String?, typeName: String?, weightName: String?) {
        self.id = id
        self.title = title
        self.catID = catID
        self.catName = catName
        self.sectionName = sectionName
        self.volumeName = volumeName
        self.sizeName = sizeName
        self.price = price
        self.rate = rate
        self.image = image
        self.typeName = typeName
        self.weightName = weightName
    }
}
