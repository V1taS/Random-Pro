//
//  GiftsScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct GiftsScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String

  /// Список результатов
  let listResult: [String]

  /// Язык для генерации подарка
  let language: Language?

  /// Пол для генерации подарка
  let gender: Gender?

  // MARK: - Language

  enum Language: String, UserDefaultsCodable {

    /// Английский
    case en

    /// Русский
    case ru
  }

  // MARK: - Gender

  enum Gender: String, UserDefaultsCodable {

    /// Мужской
    case male

    /// Женский
    case female
  }
}
