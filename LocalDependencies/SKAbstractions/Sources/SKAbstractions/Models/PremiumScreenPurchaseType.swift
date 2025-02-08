//
//  PremiumScreenPurchaseType.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import Foundation

public enum PremiumScreenPurchaseType: CaseIterable {

  /// ID продукта
  public var productIdentifiers: String {
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
