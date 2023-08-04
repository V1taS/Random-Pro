//
//  DynamicLinkType.swift
//  Random
//
//  Created by Vitalii Sosin on 30.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum DynamicLinkType: CaseIterable, UserDefaultsCodable {
  static var allCases: [DynamicLinkType] = [.freePremium, .invite(userInfo: "")]
  
  var rawValue: String {
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
