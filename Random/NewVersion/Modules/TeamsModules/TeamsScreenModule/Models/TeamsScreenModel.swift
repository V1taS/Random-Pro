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
    
    /// Уникальный номер игрока
    var id: String
    
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
  enum PlayerState: PlayerStateProtocol, UserDefaultsCodable {
    
    /// Состояние по умолчанию
    case random
    
    /// Не играет
    case doesNotPlay
    
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
    
    /// Описание каждого состояния
    var localizedName: String {
      let appearance = Appearance()
      switch self {
      case .random:
        return appearance.randomTitle
      case .doesNotPlay:
        return appearance.doesNotPlayTitle
      case .teamOne:
        return appearance.teamTitle + " - 1"
      case .teamTwo:
        return appearance.teamTitle + " - 2"
      case .teamThree:
        return appearance.teamTitle + " - 3"
      case .teamFour:
        return appearance.teamTitle + " - 4"
      case .teamFive:
        return appearance.teamTitle + " - 5"
      case .teamSix:
        return appearance.teamTitle + " - 6"
      }
    }
  }
}

// MARK: - Appearance

private extension TeamsScreenModel {
  struct Appearance {
    let randomTitle = NSLocalizedString("Рандом", comment: "")
    let doesNotPlayTitle = NSLocalizedString("Не играет", comment: "")
    let teamTitle = NSLocalizedString("Команда", comment: "")
  }
}
