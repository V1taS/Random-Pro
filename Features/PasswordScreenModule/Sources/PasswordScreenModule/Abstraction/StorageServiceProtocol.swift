//
//  StorageServiceProtocol.swift
//  PasswordScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для паролей
  var passwordScreenModel: PasswordScreenModelProtocol? { get set }
}

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
