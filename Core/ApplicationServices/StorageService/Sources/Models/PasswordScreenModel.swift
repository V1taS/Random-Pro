//
//  PasswordScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

// MARK: - PasswordScreenModel

struct PasswordScreenModel: Codable, PasswordScreenModelProtocol {
  
  /// Длина пароля
  let passwordLength: String?
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Состояние тумблеров
  let switchState: PasswordScreenSwitchStateProtocol
  
  // MARK: - Initialization
  
  init(passwordLength: String?,
       result: String,
       listResult: [String],
       switchState: SwitchState) {
    self.passwordLength = passwordLength
    self.result = result
    self.listResult = listResult
    self.switchState = switchState
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    passwordLength = try container.decode(String.self, forKey: .passwordLength)
    result = try container.decode(String.self, forKey: .result)
    listResult = try container.decode([String].self, forKey: .listResult)
    switchState = try container.decode(SwitchState.self, forKey: .switchState)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(passwordLength, forKey: .passwordLength)
    try container.encode(result, forKey: .result)
    try container.encode(listResult, forKey: .listResult)
    try container.encode(switchState as? SwitchState, forKey: .switchState)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case passwordLength
    case result
    case listResult
    case switchState
  }
}

// MARK: - SwitchState

/// Состояние тумблеров
struct SwitchState: Codable, PasswordScreenSwitchStateProtocol{
  
  /// Прописные буквы
  let uppercase: Bool
  
  /// Строчные буквы
  let lowercase: Bool
  
  /// Числа
  let numbers: Bool
  
  /// Символы
  let symbols: Bool
}

// MARK: - toCodable

extension PasswordScreenModelProtocol {
  func toCodable() -> PasswordScreenModel? {
    guard let switchState = switchState as? SwitchState else {
      return nil
    }
    return PasswordScreenModel(passwordLength: passwordLength,
                               result: result,
                               listResult: listResult,
                               switchState: switchState)
  }
}
