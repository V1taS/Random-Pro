//
//  PasswordScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - PasswordScreenModelProtocol

public protocol PasswordScreenModelProtocol {
  
  /// Длина пароля
  var passwordLength: String? { get }
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Состояние тумблеров
  var switchState: PasswordScreenSwitchStateProtocol { get }
}

// MARK: - PasswordScreenSwitchStateProtocol

public protocol PasswordScreenSwitchStateProtocol {
  
  /// Прописные буквы
  var uppercase: Bool { get }
  
  /// Строчные буквы
  var lowercase: Bool { get }
  
  /// Числа
  var numbers: Bool { get }
  
  /// Символы
  var symbols: Bool { get }
}
