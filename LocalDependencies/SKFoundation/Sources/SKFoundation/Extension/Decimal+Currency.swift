//
//  Decimal+Currency.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 23.04.2024.
//

import Foundation

/// Определение enum для выбора формата числа
public enum NumberFormatType {
  /// Целое число без десятичных знаков
  case integer
  /// Две (2) десятичные цифры
  case precise
  /// Восемь (8) десятичных цифр
  case superPrecise
}

/// Расширение для типа Decimal
extension Decimal {
  /// Функция форматирования суммы с учетом валюты и выбранного формата
  public func format(currency: String? = nil, formatType: NumberFormatType = .integer) -> String {
    /// Создание и настройка NumberFormatter
    let formatter = NumberFormatter()
    /// Установка стиля числа как десятичное
    formatter.numberStyle = .decimal
    /// Установка разделителя группы (разрядов) как пробел
    formatter.groupingSeparator = " "
    /// Установка десятичного разделителя как точка
    formatter.decimalSeparator = "."
    
    /// Настройка форматирования в соответствии с выбранным типом
    switch formatType {
    case .integer:
      /// Не показывать десятичные цифры
      formatter.maximumFractionDigits = .zero
    case .precise:
      /// Показывать две десятичные цифры
      formatter.maximumFractionDigits = 2
      formatter.minimumFractionDigits = 2
    case .superPrecise:
      /// Показывать восемь десятичных цифр
      formatter.maximumFractionDigits = 8
      formatter.minimumFractionDigits = 8
    }
    
    let number = NSDecimalNumber(decimal: self)
    if let formattedNumber = formatter.string(from: number) {
      // Добавление валюты к строке, если она предоставлена
      if let currency = currency {
        return "\(formattedNumber) \(currency)"
      } else {
        return formattedNumber
      }
    } else {
      return ""
    }
  }
}
