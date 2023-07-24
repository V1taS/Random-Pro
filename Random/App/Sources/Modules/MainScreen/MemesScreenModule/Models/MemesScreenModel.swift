//
//  MemesScreenModel.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct MemesScreenModel: UserDefaultsCodable {
  
  /// Ссылки на мемасики
  var memesURLString: [String]
  
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
