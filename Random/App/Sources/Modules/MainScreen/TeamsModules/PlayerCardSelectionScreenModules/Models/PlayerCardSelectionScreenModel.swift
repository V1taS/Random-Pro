//
//  PlayerCardSelectionScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyUIKit
import FancyStyle

struct PlayerCardSelectionScreenModel: UserDefaultsCodable {
  
  /// Уникальный номер игрока
  var id: String = UUID().uuidString
  
  /// Имя игрока
  let name: String
  
  /// Аватарка игрока
  let avatar: String
  
  /// Стиль карточки
  let style: PlayerView.StyleCard
  
  /// Выбрана карточка игрока
  let playerCardSelection: Bool
  
  /// Премиум режим
  let isPremium: Bool
}
