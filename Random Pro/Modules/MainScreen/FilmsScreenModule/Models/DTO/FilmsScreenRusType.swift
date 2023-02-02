//
//  FilmsScreenRusType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 31.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum FilmsScreenRusType: CaseIterable {
  
  /// Название каждого кейса
  var rawvalue: String {
    switch self {
    case .top100Popular:
      return "TOP_100_POPULAR_FILMS"
    case .top250Best:
      return "TOP_250_BEST_FILMS"
    }
  }
  
  /// Количество страниц для каждого кейса
  var pageMaxCount: Int {
    switch self {
    case .top100Popular:
      return 20
    case .top250Best:
      return 13
    }
  }
  
  /// ТОП 100 популярных
  case top100Popular
  
  /// ТОП 250 лучших
  case top250Best
}
