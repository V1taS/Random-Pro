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

  /// Стиль бутылочки
  let bottleStyle: BottleStyle

  /// Состояние карточки
  var bottleState: BottleState {
    if bottleStyleSelection {
      return .checkmark
    } else {
      if isPremium {
        return .none
      } else {
        return .lock
      }
    }
  }

  enum BottleState: CaseIterable, Equatable & Codable {

    /// Заблокирована
    case lock

    /// Выбрана
    case checkmark

    /// Ничего
    case none
  }

  enum BottleStyle: String, CaseIterable, Equatable & Codable {
    
    /// Стиль по дефолту
    case defaultStyle = "Bottle"
    
    /// Красный стиль
    case red = "GoldBottle"
  }
}
