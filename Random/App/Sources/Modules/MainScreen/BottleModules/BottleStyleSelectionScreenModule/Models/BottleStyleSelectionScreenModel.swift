//
//  BottleStyleSelectionScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyUIKit
import FancyStyle

struct BottleStyleSelectionScreenModel: UserDefaultsCodable {
  
  /// Выбран стиль бутылочки
  let bottleStyleSelection: Bool
  
  /// Премиум режим
  let isPremium: Bool

  /// Премиум режим
//  let bottleState: CardLockView.CardState
  
  /// Стиль бутылочки
  let bottleStyle: BottleStyle

  enum BottleStyle: String, CaseIterable, Equatable & Codable {
    
    /// Стиль по дефолту
    case defaultStyle = "Bottle"
    
//    /// Красный стиль
//    case red = "RedBottle"
//
//    /// Зеленый стиль
//    case green = "GreenBottle"
//
//    /// Желтый стиль
//    case yellow = "YellowBottle"
//
//    /// Золотой стиль
//    case gold = "GoldBottle"
  }
}
