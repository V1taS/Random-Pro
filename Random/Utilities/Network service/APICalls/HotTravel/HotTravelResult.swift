//
//  HotTravelResult.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - KinopoiskBestFilmsResult
struct HotTravelResult: Codable {
    var success: Bool?
    var hot_tours: [Data]?
    
    struct Data: Codable {
        var id: Int?
        var link: String?
        var date: String?
        var nights: Int?
        var price: Double?
        var adults: Int?
        var region: String?
        var country: String?
        var discount: Float?
        var transfer: Bool?
        var medical_insurance: Bool?
        var pansion_name: String?
        var pansion_description: String?
        var hotel: Hotel?
    }
    
    struct Hotel: Codable {
        var id: Int?
        var name: String?
        var stars: Int
        var lat: Double
        var long: Double
        var picture: String
    }
}

extension HotTravelResult.Hotel: Equatable {
    static func == (lhs: HotTravelResult.Hotel, rhs: HotTravelResult.Hotel) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.stars == rhs.stars &&
            lhs.lat == rhs.lat &&
            lhs.long == rhs.long &&
            lhs.picture == rhs.picture
    }
}

extension HotTravelResult: Equatable {
    static func == (lhs: HotTravelResult, rhs: HotTravelResult) -> Bool {
        return
            lhs.success == rhs.success &&
            lhs.hot_tours == rhs.hot_tours
    }
}

extension HotTravelResult.Data: Equatable {
    static func == (lhs: HotTravelResult.Data, rhs: HotTravelResult.Data) -> Bool {
        return
            lhs.id == rhs.id &&
            lhs.link == rhs.link &&
            lhs.date == rhs.date &&
            lhs.nights == rhs.nights &&
            lhs.price == rhs.price &&
            lhs.adults == rhs.adults &&
            lhs.region == rhs.region &&
            lhs.country == rhs.country &&
            lhs.discount == rhs.discount &&
            lhs.transfer == rhs.transfer &&
            lhs.medical_insurance == rhs.medical_insurance &&
            lhs.pansion_name == rhs.pansion_name &&
            lhs.pansion_description == rhs.pansion_description &&
            lhs.hotel == rhs.hotel
    }
}
