//
//  LetterScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct LetterScreenModel: UserDefaultsCodable, SettingsScreenModel {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Без повторений
  let isEnabledWithoutRepetition: Bool
  
  /// Индекс выбранного языка
  let languageIndexSegmented: Int
}
