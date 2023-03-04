//
//  StorageServiceProtocol.swift
//  ContactScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для контактов
  var contactScreenModel: ContactScreenModelProtocol? { get set }
}

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
