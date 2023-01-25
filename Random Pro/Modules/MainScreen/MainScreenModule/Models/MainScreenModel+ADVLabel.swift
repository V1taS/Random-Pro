//
//  MainScreenModel+ADVLabel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

extension MainScreenModel {
  // MARK: - ADVLabel
  
  enum ADVLabel: String, CaseIterable, UserDefaultsCodable {
    
    var title: String {
      let appearance = Appearance()
      switch self {
      case .hit:
        return appearance.hit
      case .new:
        return appearance.new
      case .premium:
        return appearance.premium
      case .none:
        return ""
      }
    }
    
    /// Лайбл: `ХИТ`
    case hit
    
    /// Лайбл: `НОВОЕ`
    case new
    
    /// Лайбл: `ПРЕМИУМ`
    case premium
    
    /// Лайбл: `Пусто`
    case none
  }
}
