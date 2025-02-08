//
//  SlogansScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

struct SlogansScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String

  /// Список результатов
  let listResult: [String]

  /// Язык для генерации имени
  let language: Language?

  // MARK: - Language

  enum Language: String, UserDefaultsCodable {

    /// Английский
    case en

    /// Русский
    case ru
  }
}
