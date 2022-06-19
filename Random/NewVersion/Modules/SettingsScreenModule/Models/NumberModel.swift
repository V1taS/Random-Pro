//
//  NumberModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

// MARK: - NumberModel

extension SettingsScreenType {
  
  // MARK: - Number
  
  struct Number {
    
    /// Без повторений
    let isEnabledWithoutRepetition: Bool
    
    /// Всего чисел сгенерировано
    let numbersGenerated: String
    
    /// Последнее число
    let lastNumber: String
  }
  
  // MARK: - NumberCaseIterable
  
  enum NumberCaseIterable: CaseIterable {
    
    /// Общий список ячеек
    static var allCases: [SettingsScreenType.NumberCaseIterable] = [
      .withoutRepetition,
      .numbersGenerated,
      .lastNumber,
      .listOfNumbers,
      .cleanButton
    ]
    
    /// Без повторений
    case withoutRepetition
    
    /// Всего чисел сгенерировано
    case numbersGenerated
    
    /// Последнее число
    case lastNumber
    
    /// Список чисел
    case listOfNumbers
    
    /// Кнопка очистить
    case cleanButton
  }
}
