//
//  NumberScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct NumberScreenModel: UserDefaultsCodable, SettingsScreenModel {
  
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
