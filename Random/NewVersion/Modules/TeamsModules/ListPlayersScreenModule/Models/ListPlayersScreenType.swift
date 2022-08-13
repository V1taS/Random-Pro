//
//  ListPlayersScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - ListPlayersScreenType

/// Моделька для таблички
enum ListPlayersScreenType {
  
  /// Секция игрока
  case player(ListPlayersScreenModel.Player)
  
  /// Секция отступа
  case insets(Double)
  
  /// Секция текстового поля
  case textField(String?)
}
