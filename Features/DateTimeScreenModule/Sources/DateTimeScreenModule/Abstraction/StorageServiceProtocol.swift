//
//  StorageServiceProtocol.swift
//  DateTimeScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }

  /// Модель для даты и времени
  var dateTimeScreenModel: DateTimeScreenModelProtocol? { get set }
}

// MARK: - DateTimeScreenModelProtocol

public protocol DateTimeScreenModelProtocol {
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
}
