//
//  CoinScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

// MARK: - CoinScreenModel

struct CoinScreenModel: Codable, CoinScreenModelProtocol {
  
  /// Результат генерации
  let result: String
  
  /// Индекс изображения монеты
  let coinType: CoinScreenCoinTypeProtocol
  
  /// Список результатов
  let listResult: [String]
  
  // MARK: - Initialization
  
  init(result: String,
       coinType: CoinType,
       listResult: [String]) {
    self.result = result
    self.coinType = coinType
    self.listResult = listResult
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    result = try container.decode(String.self, forKey: .result)
    coinType = try container.decode(CoinType.self, forKey: .coinType)
    listResult = try container.decode([String].self, forKey: .listResult)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(result, forKey: .result)
    try container.encode(coinType as? CoinType, forKey: .coinType)
    try container.encode(listResult, forKey: .listResult)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case result
    case coinType
    case listResult
  }
  
  // MARK: - CoinType
  
  /// Тип монеты
  enum CoinType: Codable, CoinScreenCoinTypeProtocol {
    
    /// Орел
    case eagle
    
    /// Решка
    case tails
    
    /// Ничего
    case none
  }
}

// MARK: - toCodable

extension CoinScreenModelProtocol {
  func toCodable() -> CoinScreenModel? {
    guard let coinType = coinType as? CoinScreenModel.CoinType else {
      return nil
    }
    return CoinScreenModel(result: result,
                           coinType: coinType,
                           listResult: listResult)
  }
}
