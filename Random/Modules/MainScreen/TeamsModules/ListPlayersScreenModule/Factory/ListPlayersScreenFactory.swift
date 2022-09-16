//
//  ListPlayersScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ListPlayersScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didRecive(models: [ListPlayersScreenType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ListPlayersScreenFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameters:
  ///   - players: Список игроков
  ///   - teamsCount: Количество команд
  func createListModelFrom(players: [TeamsScreenPlayerModel], teamsCount: Int)
}

/// Фабрика
final class ListPlayersScreenFactory: ListPlayersScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenFactoryOutput?
  
  // MARK: - Internal func

  func createListModelFrom(players: [TeamsScreenPlayerModel], teamsCount: Int) {
    output?.didRecive(models: createListFrom(players: players, teamsCount: teamsCount))
  }
}

// MARK: - Private

private extension ListPlayersScreenFactory {
  func createListFrom(players: [TeamsScreenPlayerModel], teamsCount: Int) -> [ListPlayersScreenType] {
    let appearance = Appearance()
    var tableViewModels: [ListPlayersScreenType] = []
    var playersCount: Int = .zero
    
    tableViewModels.append(.insets(appearance.middleInset))
    tableViewModels.append(.textField)
    tableViewModels.append(.insets(appearance.minimumInset))
    
    if !players.isEmpty {
      let forGameCount = players.filter { $0.state != .doesNotPlay }
      tableViewModels.append(.doubleTitle(playersCount: players.count,
                                          forGameCount: forGameCount.count))
      tableViewModels.append(.divider)
    }
    
    players.reversed().forEach {
      playersCount += appearance.increase
      tableViewModels.append(.player(player: $0, teamsCount: teamsCount))
      
      if playersCount != players.count {
        tableViewModels.append(.divider)
      }
    }
    return tableViewModels
  }
}

// MARK: - Appearance

private extension ListPlayersScreenFactory {
  struct Appearance {
    let minimumInset: Double = 8
    let middleInset: Double = 16
    let increase = 1
  }
}
