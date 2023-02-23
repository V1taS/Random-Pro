//
//  NumberScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - NumberScreenModelProtocol

public protocol NumberScreenModelProtocol {
  
  /// Начало диапазона
  var rangeStartValue: String? { get }
  
  /// Конец диапазона
  var rangeEndValue: String? { get }
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Без повторений
  var isEnabledWithoutRepetition: Bool { get }
}
