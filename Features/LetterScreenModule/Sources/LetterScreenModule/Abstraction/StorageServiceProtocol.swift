//
//  StorageServiceProtocol.swift
//  LetterScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для буквы
  var letterScreenModel: LetterScreenModelProtocol? { get set }
}

// MARK: - LetterScreenModelProtocol

public protocol LetterScreenModelProtocol {
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
  
  /// Без повторений
  var isEnabledWithoutRepetition: Bool { get }
  
  /// Индекс выбранного языка
  var languageIndexSegmented: Int { get }
}
