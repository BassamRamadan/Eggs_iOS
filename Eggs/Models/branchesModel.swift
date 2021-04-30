//
//  branchesModel.swift
//  Eggs
//
//  Created by Bassam Ramadan on 1/7/21.
//  Copyright © 2021 Bassam Ramadan. All rights reserved.
//
import Foundation

// MARK: - Welcome
struct branchesModel: Codable {
    let status: Bool?
    let code: Int?
    let message: String?
    let data: [branchData]?
    
    init(status: Bool?, code: Int?, message: String?, data: [branchData]?) {
        self.status = status
        self.code = code
        self.message = message
        self.data = data
    }
}

// MARK: - Datum
struct branchData: Codable {
    let id: Int?
    let lat, lng: String?
    let cityID: Int?
    let cityName: String?
    let districtID: Int?
    let districtName, name, mobile: String?
    
    enum CodingKeys: String, CodingKey {
        case id, lat, lng
        case cityID = "city_id"
        case cityName = "city_name"
        case districtID = "district_id"
        case districtName = "district_name"
        case name, mobile
    }
    
    init(id: Int?, lat: String?, lng: String?, cityID: Int?, cityName: String?, districtID: Int?, districtName: String?, name: String?, mobile: String?) {
        self.id = id
        self.lat = lat
        self.lng = lng
        self.cityID = cityID
        self.cityName = cityName
        self.districtID = districtID
        self.districtName = districtName
        self.name = name
        self.mobile = mobile
    }
}
