//
//  CongratulationsScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CongratulationsScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Язык для генерации имени
  let language: Language?
  
  /// Тип поздравления
  let type: CongratulationsType?
  
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
  
  // MARK: - CongratulationsType
  
  enum CongratulationsType: String, CaseIterable, UserDefaultsCodable {
    
    /// Заголовок
    var title: String {
      switch self {
      case .birthday:
        return RandomStrings.Localizable.birthday
      case .newYear:
        return RandomStrings.Localizable.newYear
      case .wedding:
        return RandomStrings.Localizable.wedding
      case .anniversary:
        return RandomStrings.Localizable.anniversary
      }
    }
    
    /// Индекс для Congratulations
    var index: Int {
      switch self {
      case .birthday:
        return .zero
      case .newYear:
        return 1
      case .wedding:
        return 2
      case .anniversary:
        return 3
      }
    }
    
    /// День рождения
    case birthday = "birthday"
    
    /// Новый год
    case newYear = "new_year"
    
    /// Свадьба
    case wedding = "wedding"
    
    /// Юбилей
    case anniversary = "anniversaries"
  }
}
