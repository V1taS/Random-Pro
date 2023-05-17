//
//  NickNameScreenModel.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct NickNameScreenModel: UserDefaultsCodable {
  
  /// Результат генерации
  let result: String
  
  /// Индекс выбранной ячейки
  let indexSegmented: Int
  
  /// Список результатов
  let listResult: [String]
  
  /// Без повторений
  let isEnabledWithoutRepetition: Bool
}
