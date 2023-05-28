//
//  NamesScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct NamesScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Язык для генерации имени
  let language: Language?
  
  /// Пол для генерации имени
  let gender: Gender?
  
  // MARK: - Language
  
  enum Language: String, CaseIterable, UserDefaultsCodable {
    
    /// Немецкий
    case de
    
    /// Английский
    case en
    
    /// Итальянский
    case it
    
    /// Русский
    case ru
    
    /// Испанский
    case es
  }
  
  // MARK: - Gender
  
  enum Gender: String, UserDefaultsCodable {
    
    /// Мужской
    case male
    
    /// Женский
    case female
  }
}
