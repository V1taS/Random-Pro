//
//  SettingsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.07.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

protocol SettingsScreenModel {
  
  /// Последний результат генерации
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
  
  var result: String {
    return "?"
  }
  
  var listResult: [String] {
    return []
  }
}
