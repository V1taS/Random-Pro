//
//  CoinScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CoinScreenModel: UserDefaultsCodable, SettingsScreenModel {

  /// Результат генерации
  let result: String
  
  /// Индекс изображения монеты
  let сoinType: CoinType
  
  /// Список результатов
  let listResult: [String]
  
  /// Тип монеты
  enum CoinType: UserDefaultsCodable {
    
    /// Орел
    case eagle
    
    /// Решка
    case tails
    
    /// Ничего
    case none
  }
}
