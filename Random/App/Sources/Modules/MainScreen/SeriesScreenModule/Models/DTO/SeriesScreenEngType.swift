//
//  SeriesScreenEngType.swift
//  Random
//
//  Created by Artem Pavlov on 21.11.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum SeriesScreenEngType: CaseIterable {

  /// Все сериалы
  case allSeries

  /// Максимальное количество страниц для каждого кейса
  var pageMaxCount: Int {
    switch self {
    case .allSeries:
      return 3
    }
  }
}
