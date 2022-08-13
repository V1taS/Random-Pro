//
//  TeamsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Модель Teams
struct TeamsScreenModel: UserDefaultsCodable, SettingsScreenModel {

  /// Выбранная команда (0-5)
  let selectedTeam: Int
  
  /// Все игроки
  let allPlayers: [Player]
  
  /// Список команд
  let teams: [Team]
  
  // MARK: - Team
  
  /// Модель команды
  struct Team: UserDefaultsCodable {
    
    /// Название команды
    let name: String
    
    /// Список игроков
    let players: [Player]
  }
  
  // MARK: - Player
  
  /// Модель игрока
  struct Player: UserDefaultsCodable, PlayerProtocol {
    
    /// Имя игрока
    let name: String
    
    /// Аватарка игрока
    let avatar: Data?
    
    /// Смайлик
    let emoji: String?
    
    /// Состояние игрока
    let state: PlayerState
  }
  
  // MARK: - PlayerState
  
  /// Состояние игрока
  enum PlayerState: String, UserDefaultsCodable {
    
    /// Состояние по умолчанию
    case random
    
    /// Принудительно в команду один
    case teamOne
    
    /// Принудительно в команду два
    case teamTwo
    
    /// Принудительно в команду три
    case teamThree
    
    /// Принудительно в команду четыре
    case teamFour
    
    /// Принудительно в команду пять
    case teamFive
    
    /// Принудительно в команду шесть
    case teamSix
  }
}
