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

  /// Данные стиля для сторон монетки
  var coinStyleSpecs: (eagle: String, tails: String) {
    switch coinStyle {
    case .defaultStyle:
      return (eagle: "coin_eagle", tails: "coin_tails")
    case .black:
      return (eagle: "coin_eagle", tails: "coin_tails")
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

  enum CoinStyle: Equatable & Codable {

    /// Стиль по дефолту
    case defaultStyle

    /// Черный стиль
    case black
  }
}
