//
//  ContactScreenModelProtocol.swift
//  ApplicationModels
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - ContactScreenModelProtocol

public protocol ContactScreenModelProtocol {
  
  /// Все контакты
  var allContacts: [ContactScreenContactModelProtocol] { get }
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Текущий результат
  var result: String { get }
}

// MARK: - ContactScreenContactModelProtocol

public protocol ContactScreenContactModelProtocol {
  
  /// Имя
  var firstName: String { get }
  
  /// Фамилия
  var lastName: String { get }
  
  /// Телефон
  var telephone: String { get }
}
