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
    let data: categoryData?
    
    init(status: Bool?, code: Int?, message: String?, data: categoryData?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - DataClass
class categoryData: Codable {
    let countTotal: Int?
    let nextPageURL: String?
    let pages: Int?
    let categoryItems: [categoryItem]?
    
    enum CodingKeys: String, CodingKey {
        case countTotal = "count_total"
        case nextPageURL = "nextPageUrl"
        case pages
        case categoryItems = "data"
    }
    
    init(countTotal: Int?, nextPageURL: String?, pages: Int?, categoryItems: [categoryItem]?) {
        self.countTotal = countTotal
        self.nextPageURL = nextPageURL
        self.pages = pages
        self.categoryItems = categoryItems
    }
}

// MARK: - Datum
class categoryItem: Codable {
    let id: Int?
    let title, note: String?
    let image: String?
    let products: Int?
    
    init(id: Int?, title: String?, note: String?, image: String?, products: Int?) {
        self.id = id
        self.title = title
        self.note = note
        self.image = image
        self.products = products
    }
}
