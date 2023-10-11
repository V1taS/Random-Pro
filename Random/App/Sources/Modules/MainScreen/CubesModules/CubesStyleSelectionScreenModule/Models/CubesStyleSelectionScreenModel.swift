//
//  CubesStyleSelectionScreenModel.swift
//  Random
//
//  Created by Сергей Юханов on 05.10.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct CubesStyleSelectionScreenModel: UserDefaultsCodable {

  /// Выбран стиль кубиков
  let cubesStyleSelection: Bool

  /// Премиум режим
  let isPremium: Bool

  /// Стиль кубиков
  let cubesStyle: CubesStyle

  /// Состояние карточки
  var cubesState: CubesState {
    if cubesStyleSelection {
      return .checkmark
    } else {
      if isPremium {
        return .none
      } else {
        return .lock
      }
    }
  }

  enum CubesState: CaseIterable, Equatable & Codable {

    /// Заблокирована
    case lock

    /// Выбрана
    case checkmark

    /// Ничего
    case none
  }

  enum CubesStyle: String, CaseIterable, Equatable & Codable {

    /// Стиль по дефолту
    case defaultStyle = "Bottle"

    /// Черный стиль
    case black = "BlackBottle"

    /// Темно-золотой стиль
    case darkGold = "DarkGoldBottle"

    /// Темно-зеленый стиль
    case darkGreen = "DarkGreenBottle"

    /// Темно-синий стиль
    case darkBlue = "DarkBlueBottle"

    /// Темно-красный стиль
    case darkRed = "DarkRedBottle"

    /// Темно-фиолетовый стиль
    case darkPurple = "DarkPurpleBottle"

    /// Темно-оранжевый стиль
    case darkOrange = "DarkOrangeBottle"

    /// Салатовый стиль
    case salad = "SaladBottle"

    /// Красный стиль
    case red = "RedBottle"

    /// Зеленый стиль
    case green = "GreenBottle"

    /// Фиолетовый стиль
    case purple = "PurpleBottle"

    /// Светло-синий стиль
    case lightBlue = "LightBlueBottle"

    ///  Золотой стиль
    case gold = "GoldBottle"

    /// Розовый стиль
    case pink = "PinkBottle"

    /// Стиль мультиколор зеленый
    case multicolorGreenBottle = "MulticolorGreenBottle"

    /// Стиль мультиколор с кругами
    case roundMulticolorBottle = "RoundMulticolorBottle"

    /// Стиль мультиколор с углами
    case cornerMulticolorBottle = "CornerMulticolorBottle"

    /// Стиль мультиколор с линиями
    case reflectionMulticolorBottle = "ReflectionMulticolorBottle"

    /// Стиль мультиколор алмаз
    case rubyMulticolorBottle = "RubyMulticolorBottle"
  }
}
