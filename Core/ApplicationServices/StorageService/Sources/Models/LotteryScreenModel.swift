//
//  LotteryScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

struct LotteryScreenModel: Codable, LotteryScreenModelProtocol {
  
  /// Начало диапазона
  let rangeStartValue: String?
  
  /// Конец диапазона
  let rangeEndValue: String?
  
  /// Количество цифр
  let amountValue: String?
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
}

// MARK: - toCodable

extension LotteryScreenModelProtocol {
  func toCodable() -> LotteryScreenModel? {
    return LotteryScreenModel(rangeStartValue: rangeStartValue,
                              rangeEndValue: rangeEndValue,
                              amountValue: amountValue,
                              result: result,
                              listResult: listResult)
  }
}
