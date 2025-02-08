//
//  String+OffsetBy.swift
//  
//
//  Created by Vitalii Sosin on 26.08.2022.
//

import Foundation

public extension String {
  
  /// Проверяет, равен ли символ числу
  var isNumber: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
  }
  
  /// Проверяет, равен ли символ символу
  var isSymbols: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.symbols.inverted) == nil
  }
  
  /// Проверяет, написан ли символ с большой буквы
  var isCapitalizedLetters: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.capitalizedLetters.inverted) == nil
  }
  
  /// Проверяет, написан ли символ с маленькой буквы
  var isLowercaseLetters: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.lowercaseLetters.inverted) == nil
  }
  
  /// Проверяет, равен ли символ слову
  var isLetters: Bool {
    return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
  }
  
  /// Получить символ по индексу
  subscript(idx: Int) -> String {
    String(self[index(startIndex, offsetBy: idx)])
  }
}
