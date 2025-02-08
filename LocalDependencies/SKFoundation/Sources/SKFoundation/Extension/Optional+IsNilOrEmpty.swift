//
//  Collection+Optional.swift
//
//
//  Created by Vitalii Sosin on 27.01.2024.
//

import Foundation

// Расширение для Optional типа, где Wrapped является строкой
extension Optional where Wrapped == String {
  /// Проверяет, является ли строка nil или пустой.
  public var isNilOrEmpty: Bool {
    // Проверяем строку на nil и пустоту
    return self?.isEmpty ?? true
  }
}

extension Optional where Wrapped: Collection {
  /// Проверяет, является ли массив nil или пустым.
  public var isNilOrEmpty: Bool {
    // Проверяем массив на nil и пустоту
    return self?.isEmpty ?? true
  }
}
