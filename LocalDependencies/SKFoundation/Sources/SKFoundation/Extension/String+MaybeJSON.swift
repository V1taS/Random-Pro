//
//  String+MaybeJSON.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 12.05.2024.
//

import Foundation

extension String {
  /// Проверяет, может ли строка быть JSON-объектом.
  /// Строка считается возможным JSON-объектом, если она начинается с `{`, заканчивается на `}`,
  /// и её длина больше трёх символов.
  ///
  /// Пример использования:
  /// ```
  /// let jsonString = "{\"key\": \"value\"}"
  /// let nonJsonString = "{not json}"
  /// let anotherNonJson = "Just a string"
  /// print(jsonString.maybeJSON) // Выведет: true
  /// print(nonJsonString.maybeJSON) // Выведет: true
  /// print(anotherNonJson.maybeJSON) // Выведет: false
  /// ```
  public var maybeJSON: Bool {
    return hasPrefix("{") && hasSuffix("}") && count > 3
  }
}
