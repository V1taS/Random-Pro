//
//  ContactScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - ContactScreenModel

public struct ContactScreenModel: Codable {
  
  /// Все контакты
  public let allContacts: [Contact]
  
  /// Список результатов
  public let listResult: [String]
  
  /// Текущий результат
  public let result: String
  
  // MARK: - Contact
  
  /// Контакт
  public struct Contact: Codable {
    
    /// Имя
    public let firstName: String
    
    /// Фамилия
    public let lastName: String
    
    /// Телефон
    public let telephone: String
  }
}
