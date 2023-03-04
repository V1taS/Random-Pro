//
//  LetterScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct LetterScreenModel: Codable, LetterScreenModelProtocol {
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Без повторений
  let isEnabledWithoutRepetition: Bool
  
  /// Индекс выбранного языка
  let languageIndexSegmented: Int
}

// MARK: - toCodable

extension LetterScreenModelProtocol {
  func toCodable() -> LetterScreenModel? {
    return LetterScreenModel(result: result,
                             listResult: listResult,
                             isEnabledWithoutRepetition: isEnabledWithoutRepetition,
                             languageIndexSegmented: languageIndexSegmented)
  }
}
