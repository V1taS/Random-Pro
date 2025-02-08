//
//  MemesScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct MemesScreenModel: UserDefaultsCodable {
  
  /// Язык для генерации цитаты
  let language: Language?
  
  /// Типы мемов
  let types: [MemesType]
  
  // MARK: - Language
  
  enum Language: String, CaseIterable, UserDefaultsCodable {
    
    /// Английский
    case en
    
    /// Русский
    case ru
  }
  
  // MARK: - MemesType
  
  enum MemesType: String, CaseIterable, UserDefaultsCodable {
    
    /// Заголовок
    var title: String {
      switch self {
      case .work:
        return RandomStrings.Localizable.work
      case .animals:
        return RandomStrings.Localizable.animals
      case .popular:
        return RandomStrings.Localizable.populars
      }
    }
    
    /// Мемы на работе
    case work
    
    /// Мемы с животными
    case animals
    
    /// Популярные мемы
    case popular
  }
}
