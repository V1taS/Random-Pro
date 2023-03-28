//
//  TeamsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Модель Teams
public struct TeamsScreenModel: Codable {
  
  /// Выбранная команда (1-6)
  public let selectedTeam: Int
  
  /// Все игроки
  public let allPlayers: [TeamsScreenPlayerModel]
  
  /// Список команд
  public let teams: [Team]

  // MARK: - Team
  
  /// Модель команды
  public struct Team: Codable {
    
    /// Название команды
    public let name: String
    
    /// Список игроков
    public let players: [TeamsScreenPlayerModel]
  }
}
