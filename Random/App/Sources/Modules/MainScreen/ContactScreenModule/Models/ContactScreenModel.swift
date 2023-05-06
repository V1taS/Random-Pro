//
//  ContactScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

struct ContactScreenModel: UserDefaultsCodable {
  
  /// Все контакты
  let allContacts: [Contact]
  
  /// Список результатов
  let listResult: [String]
  
  /// Текущий результат
  let result: String
  
  /// Контакт
  struct Contact: UserDefaultsCodable {
    
    /// Имя
    let firstName: String
    
    /// Фамилия
    let lastName: String
    
    /// Телефон
    let telephone: String
  }
}
