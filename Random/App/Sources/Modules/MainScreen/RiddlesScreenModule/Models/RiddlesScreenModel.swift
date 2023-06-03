//
//  RiddlesScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct RiddlesScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: Riddles
  
  /// Список результатов
  let listResult: [Riddles]
  
  /// Язык для генерации имени
  let language: Language?
  
  /// Тип сложности
  let type: DifficultType
  
  // MARK: - Language
  
  enum Language: String, CaseIterable, UserDefaultsCodable {
    
    /// Английский
    case en
    
    /// Русский
    case ru
  }
  
  // MARK: - Riddles
  
  struct Riddles: UserDefaultsCodable {
    
    /// Загадка
    let question: String
    
    /// Ответ
    let answer: String
  }
  
  // MARK: - CongratulationsType
  
  enum DifficultType: String, CaseIterable, UserDefaultsCodable {
    
    /// Заголовок
    var title: String {
      switch self {
      case .easy:
        return RandomStrings.Localizable.easy
      case .hard:
        return RandomStrings.Localizable.hard
      }
    }
    
    /// Индекс
    var index: Int {
      switch self {
      case .easy:
        return .zero
      case .hard:
        return 1
      }
    }
    
    /// Легко
    case easy
    
    /// Сложно
    case hard
  }
}
