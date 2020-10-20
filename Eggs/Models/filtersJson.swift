//
//  filtersJson.swift
//  Eggs
//
//  Created by Bassam Ramadan on 10/19/20.
//  Copyright © 2020 Bassam Ramadan. All rights reserved.
//

import Foundation

class filtersJson: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: [filtersData]?
    
    init(status: Bool?, code: Int?, message: String?, data: [filtersData]?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

class filtersData: Codable{
    internal init(id: Int?, title: String?) {
        self.id = id
        self.title = title
    }
    
    let id:Int?
    let title: String?
    
}
