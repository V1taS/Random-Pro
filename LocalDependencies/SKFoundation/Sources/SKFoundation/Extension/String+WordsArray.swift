//
//  String+WordsArray.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 19.05.2024.
//

import Foundation

public extension String {
  /// Преобразует строку в массив слов, удаляя начальные и конечные пробелы и игнорируя пустые элементы.
  /// - Returns: Массив слов из строки.
  func wordsArray() -> [String] {
    return self.trimmingCharacters(in: .whitespaces)
      .split(separator: " ")
      .map(String.init)
  }
}
