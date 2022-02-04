//
//  GlobalConstants.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI
import StoreKit

enum ProductSubscriptionIDs: String, CaseIterable {
    case tipForTea = "com.sosinvitalii.Random.TipForTea"
    case tipForWine = "com.sosinvitalii.Random.TipForWine"
    case tipForBreakfast = "com.sosinvitalii.Random.TipForBreakfast"
    case tipForLunch = "com.sosinvitalii.Random.TipForLunch"
    case tipForDinner = "com.sosinvitalii.Random.TipForDinner"
    case tipForDateWithMyGirlfriend = "com.sosinvitalii.Random.TipForDateWithMyGirlfriend"
    case tipForTravel = "com.sosinvitalii.Random.TipForTravel"
    
    ///  Месячная подписка
    case monthlySubscription = "com.sosinvitalii.Random.MonthlySubscription"
    
    ///  Годовая подписка
    case yearsSubscription = "com.sosinvitalii.Random.YearsSubscription"
    
    ///  Разовая покупка навсегда
    case lifePlan = "com.sosinvitalii.Random.LifePlan"
    
    static var allSubscription: [String] { self.allCases.map { $0.rawValue } }
    
    static func getSKProduct(type: Self, productsSKP: [SKProduct]) -> SKProduct? {
        let product = productsSKP.filter { $0.productIdentifier == type.rawValue }
        return product.first
    }
}

enum GlobalConstants {
    static var premiumUserDefaultsID: String { "RandomPremium" }
    static var ownerPremiumUserDefaultsID: String { "OwnerRandomPremium" }
    static var recordClickUserDefaultsID: String { "RandomRecordClick" }
    static var firstStart: String { "RandomFirstStart" }
    static var adDisplayInterval: Int { 15 }
}
