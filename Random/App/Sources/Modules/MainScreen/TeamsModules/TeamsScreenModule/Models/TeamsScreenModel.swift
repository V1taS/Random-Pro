//
//  TeamsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Модель Teams
struct TeamsScreenModel: UserDefaultsCodable {
  
  /// Выбранная команда (1-6)
  let selectedTeam: Int
  
  /// Все игроки
  let allPlayers: [TeamsScreenPlayerModel]
  
  /// Список команд
  let teams: [Team]
  
  // MARK: - Team
  
  /// Модель команды
  struct Team: UserDefaultsCodable {
    
    var id = UUID().uuidString
    
    /// Название команды
    let name: String
    
    /// Список игроков
    let players: [TeamsScreenPlayerModel]
  }
}
