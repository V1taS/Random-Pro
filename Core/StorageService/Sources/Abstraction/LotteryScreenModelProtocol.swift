//
//  LotteryScreenModelProtocol.swift
//  StorageService
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - LotteryScreenModelProtocol

public protocol LotteryScreenModelProtocol {
  
  /// Начало диапазона
  var rangeStartValue: String? { get }
  
  /// Конец диапазона
  var rangeEndValue: String? { get }
  
  /// Количество цифр
  var amountValue: String? { get }
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
}

