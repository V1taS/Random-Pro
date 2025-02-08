//
//  String+FormattedWithSpaces.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 25.04.2024.
//

import Foundation

extension String {
  /// Форматирует строку, представляющую число, разделяя разряды пробелами для улучшения читаемости.
  /// Число до точки разделяется на триады с использованием пробела.
  /// Число после точки остаётся без изменений.
  ///
  /// - Returns: Отформатированная строка, где каждая группа из трёх цифр до точки разделена пробелами.
  /// Примеры:
  ///   - Ввод: "1000", Вывод: "1 000"
  ///   - Ввод: "10000", Вывод: "10 000"
  ///   - Ввод: "100000.23421", Вывод: "100 000.23421"
  public func formattedWithSpaces() -> String {
    // Разделяем строку на две части по точке
    let parts = self.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
    
    // Обработка части до точки
    let leftPart = parts[0]
    let reversedDigits = String(leftPart.reversed())
    let grouped = reversedDigits.enumerated().map { index, character in
      // Изменяем условие, чтобы добавление пробела происходило после каждых трех символов
      return (index % 3 == 2 && index != reversedDigits.count - 1) ? "\(character) " : "\(character)"
    }.joined()
    
    let formattedLeftPart = String(grouped.reversed()).trimmingCharacters(in: .whitespaces)
    
    // Если есть дробная часть, добавляем её обратно после форматирования первой части
    if parts.count > 1 {
      return "\(formattedLeftPart).\(parts[1])"
    } else {
      return formattedLeftPart
    }
  }
}
