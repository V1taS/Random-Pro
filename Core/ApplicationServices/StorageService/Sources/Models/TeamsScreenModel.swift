//
//  TeamsScreenModel.swift
//  StorageService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface
import UIKit

// MARK: - TeamsScreenModel

/// Модель Teams
struct TeamsScreenModel: Codable, TeamsScreenModelProtocol {
  
  /// Выбранная команда (1-6)
  let selectedTeam: Int
  
  /// Все игроки
  let allPlayers: [TeamsScreenPlayerModelProtocol]
  
  /// Список команд
  let teams: [TeamsScreenTeamModelProtocol]
  
  // MARK: - Initialization
  
  init(selectedTeam: Int,
       allPlayers: [Player],
       teams: [Team]) {
    self.selectedTeam = selectedTeam
    self.allPlayers = allPlayers
    self.teams = teams
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    selectedTeam = try container.decode(Int.self, forKey: .selectedTeam)
    allPlayers = try container.decode([Player].self, forKey: .allPlayers)
    teams = try container.decode([Team].self, forKey: .teams)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(selectedTeam, forKey: .selectedTeam)
    try container.encode(allPlayers as? [Player], forKey: .allPlayers)
    try container.encode(teams as? [Team], forKey: .teams)
  }
  
  // MARK: - CodingKeys
  
  enum CodingKeys: CodingKey {
    case selectedTeam
    case allPlayers
    case teams
  }
  
  // MARK: - Team
  
  /// Модель команды
  struct Team: Codable, TeamsScreenTeamModelProtocol {
    
    /// Название команды
    let name: String
    
    /// Список игроков
    let players: [TeamsScreenPlayerModelProtocol]
    
    // MARK: - Initialization
    
    init(name: String, players: [Player]) {
      self.name = name
      self.players = players
    }
    
    // MARK: - Initialization `Decode`
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decode(String.self, forKey: .name)
      players = try container.decode([Player].self, forKey: .players)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
      try container.encode(players as? [Player], forKey: .players)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: CodingKey {
      case name
      case players
    }
  }
  
  // MARK: - Player
  
  /// Модель команды
  struct Player: Codable, TeamsScreenPlayerModelProtocol {
    
    /// Уникальный номер игрока
    var id: String
    
    /// Имя игрока
    let name: String
    
    /// Аватарка игрока
    let avatar: String
    
    /// Смайлик
    let emoji: String?
    
    /// Состояние игрока
    let state: TeamsScreenPlayerStateProtocol
    
    /// Стиль карточки
    let style: TeamsScreenPlayerStyleCardProtocol
    
    // MARK: - Initialization
    
    init(id: String,
         name: String,
         avatar: String,
         emoji: String?,
         state: PlayerState,
         style: StyleCard) {
      self.id = id
      self.name = name
      self.avatar = avatar
      self.emoji = emoji
      self.state = state
      self.style = style
    }
    
    // MARK: - Initialization `Decode`
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      id = try container.decode(String.self, forKey: .id)
      name = try container.decode(String.self, forKey: .name)
      avatar = try container.decode(String.self, forKey: .avatar)
      emoji = try container.decode(String.self, forKey: .emoji)
      state = try container.decode(PlayerState.self, forKey: .state)
      style = try container.decode(StyleCard.self, forKey: .style)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(name, forKey: .name)
      try container.encode(avatar, forKey: .avatar)
      try container.encode(emoji, forKey: .emoji)
      try container.encode(state as? PlayerState, forKey: .state)
      try container.encode(style as? StyleCard, forKey: .style)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: CodingKey {
      case id
      case name
      case avatar
      case emoji
      case state
      case style
    }
  }
  
  // MARK: - StyleCard
  
  /// Стиль карточки
  public enum StyleCard: Codable, TeamsScreenPlayerStyleCardProtocol {
    
    /// Стиль по умолчанию
    case defaultStyle
    
    /// Стиль темно-зеленый
    case darkGreen
    
    /// Стиль темно-синий
    case darkBlue
    
    /// Стиль темно-оранжевый
    case darkOrange
    
    /// Стиль темно-красный
    case darkRed
    
    /// Стиль темно-фиолетовый
    case darkPurple
    
    /// Стиль темно-розовый
    case darkPink
    
    /// Стиль темно-желтый
    case darkYellow
    
    /// Цвет текста на карточке
    public static var nameTextColor: UIColor { UIColor.clear }
    
    /// Цвет фона карточки
    public static var backgroundColor: [UIColor] { [] }
  }
  
  // MARK: - Player state
  
  /// Состояние игрока
  enum PlayerState: Codable, TeamsScreenPlayerStateProtocol {
    
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
    var localizedName: String { "" }
  }
}

// MARK: - toCodable

extension TeamsScreenModelProtocol {
  func toCodable() -> TeamsScreenModel {
    let newAllPlayers: [TeamsScreenModel.Player] = allPlayers.map { player in
      return TeamsScreenModel.Player(id: player.id,
                                     name: player.name,
                                     avatar: player.avatar,
                                     emoji: player.emoji,
                                     state: (player.state as? TeamsScreenModel.PlayerState) ?? .random,
                                     style: (player.style as? TeamsScreenModel.StyleCard) ?? .defaultStyle)
    }
    let newTeams: [TeamsScreenModel.Team] = teams.map { team in
      let players: [TeamsScreenModel.Player] = team.players.map { player in
        return TeamsScreenModel.Player(id: player.id,
                                       name: player.name,
                                       avatar: player.avatar,
                                       emoji: player.emoji,
                                       state: (player.state as? TeamsScreenModel.PlayerState) ?? .random,
                                       style: (player.style as? TeamsScreenModel.StyleCard) ?? .defaultStyle)
      }
      return TeamsScreenModel.Team(name: team.name,
                                   players: players)
    }
    return TeamsScreenModel(selectedTeam: selectedTeam,
                            allPlayers: newAllPlayers,
                            teams: newTeams)
  }
}
