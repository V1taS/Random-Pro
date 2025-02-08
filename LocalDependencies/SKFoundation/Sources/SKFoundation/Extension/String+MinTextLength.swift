//
//  String+MinTextLength.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 18.03.2024.
//

extension String {
  /// Форматирует строку так, чтобы она содержала первые и последние символы с тремя точками между ними.
  /// Если длина строки не превышает указанную минимальную длину, возвращается оригинальная строка.
  /// - Parameters:
  ///   - minTextLength: Минимальная длина текста, при которой производится форматирование.
  /// - Returns: Форматированная строка или оригинальная строка, если ее длина меньше или равна `minTextLength`.
  public func formatString(minTextLength: Int) -> String {
    // Ранний выход, если длина строки не превышает минимально допустимую
    guard self.count > minTextLength else {
      return self
    }
    
    let startSubstring = self.prefix(minTextLength / 2)
    let endSubstring = self.suffix(minTextLength / 2)
    return "\(startSubstring)...\(endSubstring)"
  }
}
