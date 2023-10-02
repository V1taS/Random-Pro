//
//  CoinStyleSelectionScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CoinStyleSelectionScreenModel: UserDefaultsCodable {

  /// Выбран стиль монетки
  let coinStyleSelection: Bool

  /// Премиум режим
  let isPremium: Bool

  /// Стиль монетки
  let coinStyle: CoinStyle

  /// Состояние карточки
  var coinState: CoinState {
    if coinStyleSelection {
      return .checkmark
    } else {
      if isPremium {
        return .none
      } else {
        return .lock
      }
    }
  }

  enum CoinState: CaseIterable, Equatable & Codable {

    /// Заблокирована
    case lock

    /// Выбрана
    case checkmark
    
    /// Ничего
    case none
  }

  enum CoinStyle: CaseIterable, Equatable & Codable {

    /// Стиль по дефолту
    case defaultStyle

    /// Доллар
    case presidentDollar

    /// Рубль
    case ruble

    /// Итальянский евро
    case euroItalian

    /// Данные стиля для сторон монетки
    var coinSidesName: (eagle: String, tails: String) {
      switch self {
      case .defaultStyle:
        return (eagle: "coin_eagle", tails: "coin_tails")
      case .presidentDollar:
        return (eagle: "PresidentDollarEagle", tails: "PresidentDollarTails")
      case .ruble:
        return (eagle: "RubleEagle", tails: "RubleTails")
      case .euroItalian:
        return (eagle: "EuroItaliaEagle", tails: "EuroItaliaTails")
      }
    }
  }
}
