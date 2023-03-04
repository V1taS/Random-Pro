//
//  NumberScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct NumberScreenModel: Codable, NumberScreenModelProtocol {
  
  /// Начало диапазона
  let rangeStartValue: String?
  
  /// Конец диапазона
  let rangeEndValue: String?
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Без повторений
  let isEnabledWithoutRepetition: Bool
}

// MARK: - toCodable

extension NumberScreenModelProtocol {
  func toCodable() -> NumberScreenModel {
    return NumberScreenModel(rangeStartValue: rangeStartValue,
                             rangeEndValue: rangeEndValue,
                             result: result,
                             listResult: listResult,
                             isEnabledWithoutRepetition: isEnabledWithoutRepetition)
  }
}
