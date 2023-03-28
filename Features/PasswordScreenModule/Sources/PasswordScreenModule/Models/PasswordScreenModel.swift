//
//  PasswordScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 26.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - PasswordScreenModel

public struct PasswordScreenModel: Codable {
  
  /// Длина пароля
  public let passwordLength: String?
  
  /// Результат генерации
  public let result: String
  
  /// Список результатов
  public let listResult: [String]
  
  /// Состояние тумблеров
  public let switchState: SwitchState
  
  // MARK: - SwitchState
  
  /// Состояние тумблеров
  public struct SwitchState: Codable {
    
    /// Прописные буквы
    public let uppercase: Bool
    
    /// Строчные буквы
    public let lowercase: Bool
    
    /// Числа
    public let numbers: Bool
    
    /// Символы
    public let symbols: Bool
  }
}
