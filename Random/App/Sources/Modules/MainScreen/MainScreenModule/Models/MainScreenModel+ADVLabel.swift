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
  
  enum ADVLabel: CaseIterable, UserDefaultsCodable, Hashable {
    static var allCases: [MainScreenModel.ADVLabel] = [.hit, .new, .none, .custom(text: "")]
    
    var title: String {
      let appearance = Appearance()
      switch self {
      case .hit:
        return appearance.hit
      case .new:
        return appearance.new
      case .none:
        return ""
      case let .custom(text):
        return text
      case .adv:
        return appearance.adv
      }
    }
    
    /// Лайбл: `ХИТ`
    case hit
    
    /// Лайбл: `НОВОЕ`
    case new
    
    /// Текст с бека
    case custom(text: String)
    
    /// Реклама
    case adv
    
    /// Лайбл: `Пусто`
    case none
  }
}
