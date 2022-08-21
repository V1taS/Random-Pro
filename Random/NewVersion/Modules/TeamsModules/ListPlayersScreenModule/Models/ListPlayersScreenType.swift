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
  /// - Parameters:
  ///  - player: Текущий игрок
  ///  - teamsCount: Общее количество команд
  case player(player: ListPlayersScreenModel.Player, teamsCount: Int)
  
  /// Секция отступа
  case insets(Double)
  
  /// Секция текстового поля
  case textField
  
  /// Разделитель
  case divider
  
  /// Двойной заголовок
  /// - Parameters:
  ///  - playersCount: Всего игроков
  ///  - forGameCount: Все игроков, которые идут на игру
  case doubleTitle(playersCount: Int, forGameCount: Int)
}
