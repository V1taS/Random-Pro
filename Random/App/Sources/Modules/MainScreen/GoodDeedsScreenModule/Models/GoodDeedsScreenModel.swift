//
//  GoodDeedsScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct GoodDeedsScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  // MARK: - Language
  
  enum Language: String, CaseIterable, UserDefaultsCodable {
    
    /// Английский
    case en
    
    /// Русский
    case ru
  }
}
