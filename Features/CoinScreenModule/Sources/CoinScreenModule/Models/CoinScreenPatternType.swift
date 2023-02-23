//
//  CoinScreenPatternType.swift
//  CoinScreenModule
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

/// Шаблоны запуска обратной связи от моторчика
enum CoinScreenPatternType: HapticServicePatternTypeProtocol {
  
  /// Два тактильных события
  case slice
  
  /// Кормление крокодила
  case feedingCrocodile
  
  /// Всплеск
  case splash
}
