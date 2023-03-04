//
//  StorageServiceProtocol.swift
//  YesNoScreenModule
//
//  Created by Vitalii Sosin on 04.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - StorageServiceProtocol

public protocol StorageServiceProtocol {
  
  /// Активирован премиум в приложении
  var isPremium: Bool { get }
  
  /// Модель для Да / Нет
  var yesNoScreenModel: YesNoScreenModelProtocol? { get set }
}

// MARK: - YesNoScreenModelProtocol

public protocol YesNoScreenModelProtocol {
  
  /// Результат генерации
  var result: String { get }
  
  /// Список результатов
  var listResult: [String] { get }
}
