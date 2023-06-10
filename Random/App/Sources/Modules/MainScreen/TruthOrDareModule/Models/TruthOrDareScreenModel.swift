//
//  TruthOrDareScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct TruthOrDareScreenModel: UserDefaultsCodable {

  /// Результат генерации
  let result: String

  /// Список результатов
  let listResult: [String]

  /// Язык для генерации имени
  let language: Language?

  /// Тип результата: правда или действие
  let type: TruthOrDareType?

  // MARK: - Language

  enum Language: String, UserDefaultsCodable {

    /// Английский
    case en

    /// Русский
    case ru
  }

  // MARK: - Type

  enum TruthOrDareType: String, UserDefaultsCodable {

    /// Правда
    case truth

    /// Действие
    case dare
  }
}
