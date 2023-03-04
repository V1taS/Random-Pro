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
  
  private var storageService: StorageServiceProtocol
  private var stylePlayerCard: TeamsScreenPlayerModel.StyleCard {
    guard let card = storageService.playerCardSelectionScreenModel?.filter({
      $0.playerCardSelection
    }).first,
          let style = card.style as? TeamsScreenPlayerModel.StyleCard else {
      return .defaultStyle
    }
    return style
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис хранения
  init(storageService: StorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func createTeamsFrom(model: TeamsScreenModel) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self,
            let modelAllPlayers = model.allPlayers as? [TeamsScreenPlayerModel]else {
        return
      }
      
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
          state: (result.state as? TeamsScreenPlayerModel.PlayerState) ?? .random,
          style: self.stylePlayerCard
        )
      }
      
      var playersFiltered = allPlayers.shuffled().filter {
        $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay
      }
      let playersWithTeamsFiltered = playersFiltered.filter {
        $0.state as? TeamsScreenPlayerModel.PlayerState != .random
      }
      var playersWithoutTeamsFiltered = playersFiltered.filter {
        $0.state as? TeamsScreenPlayerModel.PlayerState == .random
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
        let playerState = (player.state as? TeamsScreenPlayerModel.PlayerState) ?? .random
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
          players: teamOnePlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamTwoPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 2",
          players: teamTwoPlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamThreePlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 3",
          players: teamThreePlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamFourPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 4",
          players: teamFourPlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamFivePlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 5",
          players: teamFivePlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
        )
        teams.append(team)
      }
      
      if !teamSixPlayers.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 6",
          players: teamSixPlayers.filter { $0.state as? TeamsScreenPlayerModel.PlayerState != .doesNotPlay }
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
  }
}
