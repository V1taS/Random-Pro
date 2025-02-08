//
//  QuoteScreenModel.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct QuoteScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Язык для генерации цитаты
  let language: Language?
  
  // MARK: - Language
  
  enum Language: String, CaseIterable, UserDefaultsCodable {
    
    /// Английский
    case en
    
    /// Русский
    case ru
  }
}
