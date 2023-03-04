//
//  ListScreenModelProtocol.swift
//  ListScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для списка
  var listScreenModel: ListScreenModelProtocol? { get set }
}

// MARK: - ListScreenModelProtocol

public protocol ListScreenModelProtocol {
  
  /// Без повторений
  var withoutRepetition: Bool { get }
  
  /// Спсиок элементов для показа
  var allItems: [ListScreenTextModelProtocol] { get }
  
  /// Временное хранилище для уникальных элементов
  var tempUniqueItems: [ListScreenTextModelProtocol] { get }
  
  /// Спсиок сгенерированных элементов
  var generetionItems: [String] { get }
  
  /// Результат генерации
  var result: String { get }
}

// MARK: - ListScreenTextModelProtocol

public protocol ListScreenTextModelProtocol {
  
  /// ID текста
  var id: String { get }
  
  /// Значение текста
  var text: String? { get }
}
