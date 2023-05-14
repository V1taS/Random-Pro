//
//  CoinScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CoinScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String
  
  /// Показать список результата
  let isShowlistGenerated: Bool
  
  /// Индекс изображения монеты
  let coinType: CoinType
  
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
