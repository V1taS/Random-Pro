//
//  PasswordScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 26.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct PasswordScreenModel: UserDefaultsCodable {
  
  /// Длина пароля
  let passwordLength: String?
  
  /// Результат генерации
  let result: String
  
  /// Список результатов
  let listResult: [String]
  
  /// Состояние тумблеров
  let switchState: SwitchState
  
  /// Состояние тумблеров
  struct SwitchState: UserDefaultsCodable {
    
    /// Прописные буквы
    let uppercase: Bool
    
    /// Строчные буквы
    let lowercase: Bool
    
    /// Числа
    let numbers: Bool
    
    /// Символы
    let symbols: Bool
  }
}
