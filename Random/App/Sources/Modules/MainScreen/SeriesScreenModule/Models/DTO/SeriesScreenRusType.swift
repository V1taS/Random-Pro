//
//  SeriesScreenRusType.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum SeriesScreenRusType: CaseIterable {

  /// Сериалы
  case tvSeries

  /// Мини-сериалы
  case miniSeries

  /// Название каждого кейса
  var rawValue: String {
    switch self {
    case .tvSeries:
      return "TV_SERIES"
    case .miniSeries:
      return "MINI_SERIES"
    }
  }

  /// Максимальное количество страниц для каждого кейса
  var pageMaxCount: Int {
    switch self {
    case .tvSeries:
      return 5
    case .miniSeries:
      return 5
    }
  }
}
