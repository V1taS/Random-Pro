//
//  LetterScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct LetterScreenModel: Codable {
  
  /// Результат генерации
  public let result: String
  
  /// Список результатов
  public let listResult: [String]
  
  /// Без повторений
  public let isEnabledWithoutRepetition: Bool
  
  /// Индекс выбранного языка
  public let languageIndexSegmented: Int
}
