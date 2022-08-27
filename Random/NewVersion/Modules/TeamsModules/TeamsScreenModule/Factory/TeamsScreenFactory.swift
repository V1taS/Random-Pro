//
//  TeamsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol TeamsScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter teams: Список команд
  func didRecive(teams: [TeamsScreenModel.Team])
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
  
  // MARK: - Internal func
  
  private func addPlayersWithTeamsFrom(model: TeamsScreenModel) {
    
  }
  
  func createTeamsFrom(model: TeamsScreenModel) {
    DispatchQueue.global(qos: .userInteractive).async {
      let appearance = Appearance()
      var teams: [TeamsScreenModel.Team] = []
      let playersFiltered = model.allPlayers.shuffled().filter { $0.state != .doesNotPlay }
      let playersWithTeamsFiltered = playersFiltered.filter { $0.state != .random }
      let playersWithoutTeamsFiltered = playersFiltered.filter { $0.state == .random }
      
      var teamOne: [TeamsScreenPlayerModel] = []
      var teamTwo: [TeamsScreenPlayerModel] = []
      var teamThree: [TeamsScreenPlayerModel] = []
      var teamFour: [TeamsScreenPlayerModel] = []
      var teamFive: [TeamsScreenPlayerModel] = []
      var teamSix: [TeamsScreenPlayerModel] = []
      
      for player in playersWithTeamsFiltered {
        if player.state == .teamOne {
          teamOne.append(player)
          continue
        }
        
        if player.state == .teamTwo {
          teamTwo.append(player)
          continue
        }
        
        if player.state == .teamThree {
          teamThree.append(player)
          continue
        }
        
        if player.state == .teamFour {
          teamFour.append(player)
          continue
        }
        
        if player.state == .teamFive {
          teamFive.append(player)
          continue
        }
        
        if player.state == .teamSix {
          teamSix.append(player)
          continue
        }
      }
      
      for player in playersWithoutTeamsFiltered {
        if model.selectedTeam == 1 {
          teamOne.append(player)
          continue
        }
        
        if model.selectedTeam == 2 {
          if teamOne.count < playersFiltered.count / model.selectedTeam {
            teamOne.append(player)
            continue
          }
          
          teamTwo.append(player)
          continue
        }
        
        if model.selectedTeam == 3 {
          if teamOne.count < playersFiltered.count / model.selectedTeam {
            teamOne.append(player)
            continue
          }
          
          if teamTwo.count < playersFiltered.count / model.selectedTeam {
            teamTwo.append(player)
            continue
          }
          
          teamThree.append(player)
          continue
        }
        
        if model.selectedTeam == 4 {
          if teamOne.count < playersFiltered.count / model.selectedTeam {
            teamOne.append(player)
            continue
          }
          
          if teamTwo.count < playersFiltered.count / model.selectedTeam {
            teamTwo.append(player)
            continue
          }
          
          if teamThree.count < playersFiltered.count / model.selectedTeam {
            teamThree.append(player)
            continue
          }
          
          teamFour.append(player)
          continue
        }
        
        if model.selectedTeam == 5 {
          if teamOne.count < playersFiltered.count / model.selectedTeam {
            teamOne.append(player)
            continue
          }
          
          if teamTwo.count < playersFiltered.count / model.selectedTeam {
            teamTwo.append(player)
            continue
          }
          
          if teamThree.count < playersFiltered.count / model.selectedTeam {
            teamThree.append(player)
            continue
          }
          
          if teamFour.count < playersFiltered.count / model.selectedTeam {
            teamFour.append(player)
            continue
          }
          
          teamFive.append(player)
          continue
        }
        
        if model.selectedTeam == 6 {
          if teamOne.count < playersFiltered.count / model.selectedTeam {
            teamOne.append(player)
            continue
          }
          
          if teamTwo.count < playersFiltered.count / model.selectedTeam {
            teamTwo.append(player)
            continue
          }
          
          if teamThree.count < playersFiltered.count / model.selectedTeam {
            teamThree.append(player)
            continue
          }
          
          if teamFour.count < playersFiltered.count / model.selectedTeam {
            teamFour.append(player)
            continue
          }
          
          if teamFive.count < playersFiltered.count / model.selectedTeam {
            teamFive.append(player)
            continue
          }
          
          teamSix.append(player)
          continue
        }
      }
      
      if !teamOne.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 1",
          players: teamOne
        )
        teams.append(team)
      }
      
      if !teamTwo.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 2",
          players: teamTwo
        )
        teams.append(team)
      }
      
      if !teamThree.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 3",
          players: teamThree
        )
        teams.append(team)
      }
      
      if !teamFour.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 4",
          players: teamFour
        )
        teams.append(team)
      }
      
      if !teamFive.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 5",
          players: teamFive
        )
        teams.append(team)
      }
      
      if !teamSix.isEmpty {
        let team = TeamsScreenModel.Team(
          name: appearance.teamTitle + " - 6",
          players: teamSix
        )
        teams.append(team)
      }
      DispatchQueue.main.async { [weak self] in
        self?.output?.didRecive(teams: teams)
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
