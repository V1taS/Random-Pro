//
//  CoinScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CoinScreenModelProtocol

public protocol CoinScreenModelProtocol {
  
  /// Результат генерации
  var result: String { get }
  
  /// Индекс изображения монеты
  var coinType: CoinScreenCoinTypeProtocol { get }
  
  /// Список результатов
  var listResult: [String] { get }
}

// MARK: - CoinScreenCoinTypeProtocol

public protocol CoinScreenCoinTypeProtocol {
  
  /// Орел
  static var eagle: Self { get }
  
  /// Решка
  static var tails: Self { get }
  
  /// Ничего
  static var none: Self { get }
}

