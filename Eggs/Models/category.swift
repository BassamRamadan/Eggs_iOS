//
//  categoryRequest.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/13/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

// MARK: - Welcome
class categoryJson: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: categoriesData?
    
    init(status: Bool?, code: Int?, message: String?, data: categoriesData?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class categoriesData: Codable {
    let countTotal: Int?
    let nextPageURL: String?
    let pages: Int?
    let categoryItems: [categoryData]?
    
    enum CodingKeys: String, CodingKey {
        case countTotal = "count_total"
        case nextPageURL = "nextPageUrl"
        case pages
        case categoryItems = "data"
    }
    
    init(countTotal: Int?, nextPageURL: String?, pages: Int?, categoryItems: [categoryData]?) {
        self.countTotal = countTotal
        self.nextPageURL = nextPageURL
        self.pages = pages
        self.categoryItems = categoryItems
    }
}

// MARK: - Datum
class categoryData: Codable {
    let id: Int?
    let title, note, name: String?
    let image: String?
    let products,rate: Int?
    
    init(id: Int?, title: String?,name: String?, note: String?, image: String?, products: Int?, rate: Int?) {
        self.id = id
        self.title = title
        self.note = note
        self.image = image
        self.products = products
        self.rate = rate
        self.name = name
    }
}
