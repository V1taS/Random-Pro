//
//  DynamicLinkType.swift
//  Random
//
//  Created by Vitalii Sosin on 30.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum DynamicLinkType: String, CaseIterable, UserDefaultsCodable {
  
  /// Приглашение
  case invite
  
  /// Бесплатный премиум
  case freePremium
}
