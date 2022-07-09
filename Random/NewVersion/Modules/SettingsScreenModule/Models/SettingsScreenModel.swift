//
//  SettingsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.07.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation

protocol SettingsScreenModel {
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Без повторений
  var isEnabledWithoutRepetition: Bool { get }
}

extension SettingsScreenModel {
  
  var isEnabledWithoutRepetition: Bool {
    return false
  }
}
