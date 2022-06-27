//
//  SettingsScreenYesOrNoModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

// MARK: - YesOrNoModel

extension SettingsScreenType {
  
  // MARK: - YesOrNo
  
  struct YesOrNo {
    
    /// Всего сгенерировано
    let numbersGenerated: String
    
    /// Последний результат
    let lastResult: String
    
    /// Список результатов
    let listResult: [String]
  }
  
  // MARK: - YesOrNoCaseIterable
  
  enum YesOrNoCaseIterable: CaseIterable {
    
    /// Общий список ячеек
    static var allCases: [SettingsScreenType.YesOrNoCaseIterable] = [
      .numbersGenerated,
      .lastResult,
      .listOfNumbers,
      .cleanButton
    ]
    
    /// Всего чисел сгенерировано
    case numbersGenerated
    
    /// Последний результат
    case lastResult
    
    /// Список результатов
    case listOfNumbers
    
    /// Кнопка очистить
    case cleanButton
  }
}
