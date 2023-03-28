//
//  NumberScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct NumberScreenModel: Codable {
  
  /// Начало диапазона
  public let rangeStartValue: String?
  
  /// Конец диапазона
  public let rangeEndValue: String?
  
  /// Результат генерации
  public let result: String
  
  /// Список результатов
  public let listResult: [String]
  
  /// Без повторений
  public let isEnabledWithoutRepetition: Bool
}
