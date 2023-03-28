//
//  TeamsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import RandomUIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol TeamsScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter teams: Список команд
  func didReceive(teams: [TeamsScreenModel.Team])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol TeamsScreenFactoryInput {
  
  /// Создать команды из модельки
  /// - Parameter model: Моделька с данными
  func createTeamsFrom(model: TeamsScreenModel)
}

/// Фабрика
final class TeamsScreenFactory: TeamsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenFactoryOutput?
  
  // MARK: - Private property
  
  private var storageService: TeamsScreeStorageServiceProtocol
  private var stylePlayerCard: PlayerCardSelectionScreenModel.StyleCard {
    guard let card = storageService.getDataWith(key: Appearance().playerCardSelectionModelKeyUserDefaults,
                                                to: [PlayerCardSelectionScreenModel].self)?.filter({
      $0.playerCardSelection
    }).first else {
      return .defaultStyle
    }
    return card.style
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис хранения
  init(storageService: TeamsScreeStorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func createTeamsFrom(model: TeamsScreenModel) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        return
      }
      
      let modelAllPlayers = model.allPlayers
      let appearance = Appearance()
      var teams: [TeamsScreenModel.Team] = []
      let allPlayers = modelAllPlayers.map { result -> TeamsScreenPlayerModel in
        var emoji: String?
        
        if result.emoji != "⚪️" {
          emoji = result.emoji
        }
        
        return TeamsScreenPlayerModel(
          id: result.id,
          name: result.name,
          avatar: result.avatar,
          emoji: emoji,
          state: result.state,
          style: self.stylePlayerCard
        )
      }
      
      var playersFiltered = allPlayers.shuffled().filter {
        $0.state != .doesNotPlay
      }
      let playersWithTeamsFiltered = playersFiltered.filter {
        $0.state != .random
      }
      var playersWithoutTeamsFiltered = playersFiltered.filter {
        $0.state == .random
      }
      
      while playersFiltered.count % model.selectedTeam != .zero {
        let plugPlayer = TeamsScreenPlayerModel(
          id: "",
          name: "",
          avatar: "",
          emoji: nil,
          state: .doesNotPlay,
          style: self.stylePlayerCard
        )
        
        playersWithoutTeamsFiltered.append(plugPlayer)
        playersFiltered.append(plugPlayer)
      }
      
      var teamOnePlayers: [TeamsScreenPlayerModel] = []
      var teamTwoPlayers: [TeamsScreenPlayerModel] = []
      var teamThreePlayers: [TeamsScreenPlayerModel] = []
      var teamFourPlayers: [TeamsScreenPlayerModel] = []
      var teamFivePlayers: [TeamsScreenPlayerModel] = []
      var teamSixPlayers: [TeamsScreenPlayerModel] = []
      var currentTeam = 1
      
      for player in playersWithTeamsFiltered {
        let playerState = player.state
        if playerState == .teamOne {
          teamOnePlayers.append(player)
          continue
        }
        
        if playerState == .teamTwo {
          teamTwoPlayers.append(player)
          continue
        }
        
        if playerState == .teamThree {
          teamThreePlayers.append(player)
          continue
        }
        
        if playerState == .teamFour {
          teamFourPlayers.append(player)
          continue
        }
        
        if playerState == .teamFive {
          teamFivePlayers.append(player)
          continue
        }
        
        if playerState == .teamSix {
          teamSixPlayers.append(player)
          continue
        }
      }
      
      for player in playersWithoutTeamsFiltered {
        if model.selectedTeam == 1 {
          teamOnePlayers.append(player)
          continue
        }
        
        if model.selectedTeam == 2 {
          if teamOnePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 1 {
            teamOnePlayers.append(player)
            currentTeam = 2
            continue
          }
          
          teamTwoPlayers.append(player)
          currentTeam = 1
          continue
        }
        
        if model.selectedTeam == 3 {
          if teamOnePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 1 {
            teamOnePlayers.append(player)
            currentTeam = 2
            continue
          }
          
          if teamTwoPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 2 {
            teamTwoPlayers.append(player)
            currentTeam = 3
            continue
          }
          
          teamThreePlayers.append(player)
          currentTeam = 1
          continue
        }
        
        if model.selectedTeam == 4 {
          if teamOnePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 1 {
            teamOnePlayers.append(player)
            currentTeam = 2
            continue
          }
          
          if teamTwoPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 2 {
            teamTwoPlayers.append(player)
            currentTeam = 3
            continue
          }
          
          if teamThreePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 3 {
            teamThreePlayers.append(player)
            currentTeam = 4
            continue
          }
          
          teamFourPlayers.append(player)
          currentTeam = 1
          continue
        }
        
        if model.selectedTeam == 5 {
          if teamOnePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 1 {
            teamOnePlayers.append(player)
            currentTeam = 2
            continue
          }
          
          if teamTwoPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 2 {
            teamTwoPlayers.append(player)
            currentTeam = 3
            continue
          }
          
          if teamThreePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 3 {
            teamThreePlayers.append(player)
            currentTeam = 4
            continue
          }
          
          if teamFourPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 4 {
            teamFourPlayers.append(player)
            currentTeam = 5
            continue
          }
          
          teamFivePlayers.append(player)
          currentTeam = 1
          continue
        }
        
        if model.selectedTeam == 6 {
          if teamOnePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 1 {
            teamOnePlayers.append(player)
            currentTeam = 2
            continue
          }
          
          if teamTwoPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 2 {
            teamTwoPlayers.append(player)
            currentTeam = 3
            continue
          }
          
          if teamThreePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 3 {
            teamThreePlayers.append(player)
            currentTeam = 4
            continue
          }
          
          if teamFourPlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 4 {
            teamFourPlayers.append(player)
            currentTeam = 5
            continue
          }
          
          if teamFivePlayers.count < playersFiltered.count / model.selectedTeam && currentTeam == 5 {
            teamFivePlayers.append(player)
            currentTeam = 6
            continue
          }
          
          teamSixPlayers.append(player)
          currentTeam = 1
          continue
        }
      }
      
      if !teamOnePlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 1",
          players: teamOnePlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamTwoPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 2",
          players: teamTwoPlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamThreePlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 3",
          players: teamThreePlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamFourPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 4",
          players: teamFourPlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamFivePlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 5",
          players: teamFivePlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamSixPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 6",
          players: teamSixPlayers.filter { $0.state != .doesNotPlay }
        )
        teams.append(team)
      }
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(teams: teams)
      }
    }
  }
}

// MARK: - Appearance

private extension TeamsScreenFactory {
  struct Appearance {
    let teamTitle = NSLocalizedString("Команда", comment: "")
    let playerCardSelectionModelKeyUserDefaults = "player_card_selection_screen_user_defaults_key"
  }
}
