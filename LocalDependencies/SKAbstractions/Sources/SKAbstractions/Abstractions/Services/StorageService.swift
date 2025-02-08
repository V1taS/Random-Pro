//
//  StorageService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol StorageService {

  /// Активирован премиум в приложении
  var isPremium: Bool { get }

  /// Сохранить данные
  /// - Parameter data: Данные
  func saveData<T: UserDefaultsCodable>(_ data: T?)

  /// Получить данные по Типу `Type.self`
  func getData<T: UserDefaultsCodable>(from: T.Type) -> T?
}
