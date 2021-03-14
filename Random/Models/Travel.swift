//
//  Travel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let success: Bool?
    let hot_tours: [HotTour]?
    let pages: Pages?
}

// MARK: - HotTour
struct HotTour: Codable {
    let id: Int?
    let link, date: String?
    let nights, price, adults: Int?
    let region, country: String?
    let discount: Int?
    let transfer, medicalInsurance: Bool?
    let pansionName, pansionDescription: String?
    let hotel: Hotel?
}

// MARK: - Hotel
struct Hotel: Codable {
    let id: Int?
    let name: String?
    let stars: Int?
    let lat, long: Double?
    let picture: String?
}

// MARK: - Pages
struct Pages: Codable {
    let count, current, total: Int?
}
