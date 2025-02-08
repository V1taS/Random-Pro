//
//  String+LocaleType.swift
//  
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import Foundation

public enum CountryType: String, CaseIterable {
  
  /// Заголовок
  public var title: String {
    switch self {
    case .de:
      return "De"
    case .us:
      return "Us"
    case .it:
      return "It"
    case .ru:
      return "Ru"
    case .es:
      return "Es"
    }
  }
  
  /// Германия
  case de
  
  /// Америка
  case us
  
  /// Италия
  case it
  
  /// Россия
  case ru
  
  /// Испания
  case es
  
  /// Получем страну которая выбрана в айфоне (`НЕ ЯЗЫК`)
  public static func getCurrentCountryType() -> CountryType? {
    if #available(iOS 16, *) {
      guard let locale = Locale.current.language.region?.identifier.lowercased() else {
        return nil
      }
      return CountryType.init(rawValue: locale)
    } else {
      guard let locale = Locale.current.regionCode?.lowercased() else {
        return nil
      }
      return CountryType.init(rawValue: locale)
    }
  }
  
  /// Получить тип из заголовка
  public static func getTypeFrom(title: String) -> CountryType {
    switch title {
    case "De":
      return .de
    case "Us":
      return .us
    case "It":
      return .it
    case "Ru":
      return .ru
    case "Es":
      return .es
    default:
      return .us
    }
  }
}

public enum LanguageType: CaseIterable {
  
  /// Заголовок
  public var title: String {
    switch self {
    case .de:
      return "De"
    case .us:
      return "En"
    case .it:
      return "It"
    case .ru:
      return "Ru"
    case .es:
      return "Es"
    }
  }
  
  /// Germany
  case de
  
  /// United States
  case us
  
  /// Italy
  case it
  
  /// Russia
  case ru
  
  /// Spain
  case es
  
  public static func getCurrentLanguageType() -> LanguageType? {
    let currentLocale = Bundle.main.preferredLocalizations.first?.prefix(2).lowercased() ?? ""
    switch currentLocale {
    case "de":
      return .de
    case "en":
      return .us
    case "it":
      return .it
    case "ru":
      return .ru
    case "es":
      return .es
    default:
      return nil
    }
  }
  
  /// Получить тип из заголовка
  public static func getTypeFrom(title: String) -> LanguageType {
    switch title {
    case "De":
      return .de
    case "En":
      return .us
    case "It":
      return .it
    case "Ru":
      return .ru
    case "Es":
      return .es
    default:
      return .us
    }
  }
}
