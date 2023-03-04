//
//  LotteryScreenModel.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 10.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

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
