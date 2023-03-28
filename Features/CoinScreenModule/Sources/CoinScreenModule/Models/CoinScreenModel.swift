//
//  CoinScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CoinScreenModel

public struct CoinScreenModel: Codable {
  
  /// Результат генерации
  public let result: String
  
  /// Индекс изображения монеты
  public let coinType: CoinType
  
  /// Список результатов
  public let listResult: [String]
  
  // MARK: - CoinType
  
  /// Тип монеты
  public enum CoinType: Codable, Equatable {
    
    /// Орел
    case eagle
    
    /// Решка
    case tails
    
    /// Ничего
    case none
  }
}
