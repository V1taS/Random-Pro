//
//  SeriesScreenRusType.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum SeriesScreenRusType: CaseIterable {

  /// Название каждого кейса
  var rawvalue: String {
    switch self {
    case .tvSeries:
      return "TV_SERIES"
    case .miniSeries:
      return "MINI_SERIES"
    }
  }

  /// Количество страниц для каждого кейса
  var pageMaxCount: Int {
    switch self {
    case .tvSeries:
      return 5
    case .miniSeries:
      return 5
    }
  }

  /// Сериалы
  case tvSeries

  /// Мини-сериалы
  case miniSeries
}
