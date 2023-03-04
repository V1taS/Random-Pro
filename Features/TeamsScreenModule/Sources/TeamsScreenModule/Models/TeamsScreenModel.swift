//
//  TeamsScreenModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

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
       allPlayers: [TeamsScreenPlayerModel],
       teams: [Team]) {
    self.selectedTeam = selectedTeam
    self.allPlayers = allPlayers
    self.teams = teams
  }
  
  // MARK: - Initialization `Decode`
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    selectedTeam = try container.decode(Int.self, forKey: .selectedTeam)
    allPlayers = try container.decode([TeamsScreenPlayerModel].self, forKey: .allPlayers)
    teams = try container.decode([Team].self, forKey: .teams)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(selectedTeam, forKey: .selectedTeam)
    try container.encode(allPlayers as? [TeamsScreenPlayerModel], forKey: .allPlayers)
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
    
    init(name: String, players: [TeamsScreenPlayerModel]) {
      self.name = name
      self.players = players
    }
    
    // MARK: - Initialization `Decode`
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      name = try container.decode(String.self, forKey: .name)
      players = try container.decode([TeamsScreenPlayerModel].self, forKey: .players)
    }
    
    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(name, forKey: .name)
      try container.encode(players as? [TeamsScreenPlayerModel], forKey: .players)
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: CodingKey {
      case name
      case players
    }
  }
}

// MARK: - toCodable

extension TeamsScreenModelProtocol {
  func toCodable() -> TeamsScreenModel {
    let newAllPlayers: [TeamsScreenPlayerModel] = allPlayers.map { player in
      return TeamsScreenPlayerModel(id: player.id,
                                    name: player.name,
                                    avatar: player.avatar,
                                    emoji: player.emoji,
                                    state: (player.state as? TeamsScreenPlayerModel.PlayerState) ?? .random,
                                    style: (player.style as? TeamsScreenPlayerModel.StyleCard) ?? .defaultStyle)
    }
    let newTeams: [TeamsScreenModel.Team] = teams.map { team in
      let players: [TeamsScreenPlayerModel] = team.players.map { player in
        return TeamsScreenPlayerModel(id: player.id,
                                      name: player.name,
                                      avatar: player.avatar,
                                      emoji: player.emoji,
                                      state: (player.state as? TeamsScreenPlayerModel.PlayerState) ?? .random,
                                      style: (player.style as? TeamsScreenPlayerModel.StyleCard) ?? .defaultStyle)
      }
      return TeamsScreenModel.Team(name: team.name,
                                   players: players)
    }
    return TeamsScreenModel(selectedTeam: selectedTeam,
                            allPlayers: newAllPlayers,
                            teams: newTeams)
  }
}
