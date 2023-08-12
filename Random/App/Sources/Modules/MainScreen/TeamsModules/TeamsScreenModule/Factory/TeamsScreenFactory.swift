//
//  TeamsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

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
  
  private var storageService: StorageService
  private var stylePlayerCard: PlayerView.StyleCard {
    let models = storageService.getData(from: [PlayerCardSelectionScreenModel].self)
    return models?.filter({$0.playerCardSelection}).first?.style ?? .defaultStyle
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func createTeamsFrom(model: TeamsScreenModel) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      guard let self else {
        return
      }
      
      let appearance = Appearance()
      
      // Initialize teams array
      var teams: [TeamsScreenModel.Team] = []
      if model.teams.isEmpty {
        // If teams do not exist, create new teams
        for numberTeam in 1...model.selectedTeam {
          teams.append(TeamsScreenModel.Team(
            id: UUID().uuidString,
            name: appearance.teamTitle + " - \(numberTeam)",
            players: []
          ))
        }
      } else {
        // If teams exist, use the existing teams up to the selected team count
        if model.teams.count > model.selectedTeam {
          // If the number of existing teams is more than the selected count,
          // use the first selectedTeam number of teams
          teams = Array(model.teams.prefix(model.selectedTeam))
        } else {
          // Otherwise use all the existing teams
          teams = model.teams
          // And if there are fewer existing teams than the selected count, create additional teams
          let additionalTeamCount = model.selectedTeam - model.teams.count
          for numberTeam in 1..<additionalTeamCount + 1 {
            teams.append(TeamsScreenModel.Team(
              id: UUID().uuidString,
              name: appearance.teamTitle + " - \(model.teams.count + numberTeam)",
              players: []
            ))
          }
        }
      }
      
      // Prepare the players
      let allPlayers = model.allPlayers.map { result in
        return TeamsScreenPlayerModel(
          id: result.id,
          name: result.name,
          avatar: result.avatar,
          emoji: result.emoji != "⚪️" ? result.emoji : nil,
          state: result.state,
          style: self.stylePlayerCard
        )
      }.shuffled().filter { $0.state != .doesNotPlay }
      
      // Separate players who have chosen their team and those who have not
      let playersWithTeams = allPlayers.filter { $0.state != .random }
      var playersWithoutTeams = allPlayers.filter { $0.state == .random }
      
      // Distribute players who have chosen their team
      let newTeams: [TeamsScreenModel.Team] = teams.map { oldTeam in
        // Filter playersWithTeams for those whose state matches the team's index
        let index = teams.firstIndex(of: oldTeam) ?? .zero
        let relevantState: TeamsScreenPlayerModel.PlayerState
        switch index {
        case 0: relevantState = .teamOne
        case 1: relevantState = .teamTwo
        case 2: relevantState = .teamThree
        case 3: relevantState = .teamFour
        case 4: relevantState = .teamFive
        case 5: relevantState = .teamSix
        default: relevantState = .random
        }
        let newPlayers = playersWithTeams.filter { $0.state == relevantState }
        return TeamsScreenModel.Team(id: oldTeam.id, name: oldTeam.name, players: newPlayers)
      }
      teams = newTeams
      
      // Create a mutable copy of teams
      var tempTeams = teams.map { team in
        return (id: team.id, name: team.name, players: team.players)
      }
      
      // Distribute players who have not chosen their team
      while !playersWithoutTeams.isEmpty {
        for index in tempTeams.indices where !playersWithoutTeams.isEmpty {
          tempTeams[index].players.append(playersWithoutTeams.removeFirst())
        }
      }
      
      // Create a new model with updated teams
      teams = tempTeams.map { team in
        return TeamsScreenModel.Team(id: team.id, name: team.name, players: team.players)
      }
      
      // Filter out teams without players
      teams = teams.filter { !$0.players.isEmpty }
      
      DispatchQueue.main.async { [weak self] in
        self?.output?.didReceive(teams: teams)
      }
    }
  }
}

// MARK: - Appearance

private extension TeamsScreenFactory {
  struct Appearance {
    let teamTitle = RandomStrings.Localizable.team
  }
}
