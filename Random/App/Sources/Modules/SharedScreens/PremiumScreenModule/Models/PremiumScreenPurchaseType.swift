//
//  PremiumScreenPurchaseType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum PremiumScreenPurchaseType: CaseIterable {
  
  /// ID продукта
  var productIdentifiers: String {
    switch self {
    case .yearly:
      return "com.sosinvitalii.Random.YearlyPremiumAccess"
    case .monthly:
      return "com.sosinvitalii.Random.MonthlyPremiumAccess"
    case .lifetime:
      return "com.sosinvitalii.Random.OneTimePurchasePremiumAccess"
    case .lifetimeSale:
      return "com.sosinvitalii.Random.OneTimePurchasePremiumAccessSale"
    }
  }
  
  /// Ежемесячная подписка
  case monthly
  
  /// Ежегодная подписка
  case yearly
  
  /// Погупка навсегда
  case lifetime
  
  /// Погупка навсегда (Распродажа)
  case lifetimeSale
}
