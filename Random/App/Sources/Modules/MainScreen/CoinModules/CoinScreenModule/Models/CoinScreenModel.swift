//
//  CoinScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct CoinScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String
  
  /// Показать список результата
  let isShowlistGenerated: Bool

  /// Стиль монеты
  let coinStyle: CoinStyleSelectionScreenModel.CoinStyle

  /// Тип стороны монеты
  let coinSideType: CoinSideType
  
  /// Список результатов
  let listResult: [String]
  
  /// Тип стороны монеты
  enum CoinSideType: UserDefaultsCodable {
    
    /// Орел
    case eagle
    
    /// Решка
    case tails
    
    /// Ничего
    case none
  }
}
