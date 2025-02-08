//
//  String+SingleSpaced.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 12.05.2024.
//

import Foundation

extension String {
  /// Возвращает строку, в которой начальные и конечные пробелы и переводы строк удалены,
  /// а между словами остаётся только один пробел.
  ///
  /// Пример использования:
  /// ```
  /// let example = "  Пример   строки с    несколькими    пробелами  "
  /// print(example.singleSpaced) // "Пример строки с несколькими пробелами"
  /// ```
  public var singleSpaced: String {
    // Удаление пробелов и переносов строк с начала и конца строки.
    let trimmedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
    // Замена одного или более пробелов на один пробел.
    let singleSpacedString = trimmedString.replacingOccurrences(
      of: "\\s+",
      with: " ",
      options: .regularExpression,
      range: nil
    )
    return singleSpacedString
  }
}
