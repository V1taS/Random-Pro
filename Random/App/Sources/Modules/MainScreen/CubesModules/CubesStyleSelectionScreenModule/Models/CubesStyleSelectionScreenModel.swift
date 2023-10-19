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
    case defaultStyle = "die.five"

    /// Темно-синий стиль
    case darkBlue = "blue.die.five"

    /// Красный стиль
    case red = "red.die.five"

    /// Зеленый стиль
    case green = "green.die.five"

    /// Фиолетовый стиль
    case purple = "purple.die.five"

    /// Данные стиля для сторон кубиков
    var cubesSidesName: (one: String, two: String, three: String, four: String, five: String, six: String) {
      switch self {
      case .defaultStyle:
        return (one: "die.one",
                two: "die.two",
                three: "die.three",
                four: "die.four",
                five: "die.five",
                six: "die.six")
      case .darkBlue:
        return (one: "blue.die.one",
                two: "blue.die.two",
                three: "blue.die.three",
                four: "blue.die.four",
                five: "blue.die.five",
                six: "blue.die.six")
      case .red:
        return (one: "red.die.one",
                two: "red.die.two",
                three: "red.die.three",
                four: "red.die.four",
                five: "red.die.five",
                six: "red.die.six")
      case .green:
        return (one: "green.die.one",
                two: "green.die.two",
                three: "green.die.three",
                four: "green.die.four",
                five: "green.die.five",
                six: "green.die.six")
      case .purple:
        return (one: "purple.die.one",
                two: "purple.die.two",
                three: "purple.die.three",
                four: "purple.die.four",
                five: "purple.die.five",
                six: "purple.die.six")
      }
    }
  }
}
