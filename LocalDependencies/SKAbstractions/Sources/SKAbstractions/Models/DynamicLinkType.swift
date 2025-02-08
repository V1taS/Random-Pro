//
//  DynamicLinkType.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public enum DynamicLinkType: CaseIterable, UserDefaultsCodable {
  public static var allCases: [DynamicLinkType] = [.freePremium, .invite(userInfo: "")]

  public var rawValue: String {
    switch self {
    case .invite:
      return "invite"
    case .freePremium:
      return "freePremium"
    }
  }

  /// Приглашение
  case invite(userInfo: String)

  /// Бесплатный премиум
  case freePremium
}
