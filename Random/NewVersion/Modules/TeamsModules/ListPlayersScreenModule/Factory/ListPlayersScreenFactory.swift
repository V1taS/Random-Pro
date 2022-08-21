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
  ///  - Parameter model: Модель с данными
  func createListModelFrom(model: ListPlayersScreenModel)
}

/// Фабрика
final class ListPlayersScreenFactory: ListPlayersScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelFrom(model: ListPlayersScreenModel) {
    output?.didRecive(models: createListFrom(model: model))
  }
}

// MARK: - Private

private extension ListPlayersScreenFactory {
  func createListFrom(model: ListPlayersScreenModel) -> [ListPlayersScreenType] {
    let appearance = Appearance()
    var tableViewModels: [ListPlayersScreenType] = []
    var playersCount: Int = .zero
    
    tableViewModels.append(.insets(appearance.middleInset))
    tableViewModels.append(.textField)
    tableViewModels.append(.insets(appearance.minimumInset))
    
    if !model.players.isEmpty {
      let forGameCount = model.players.filter { $0.state != .doesNotPlay }
      tableViewModels.append(.doubleTitle(playersCount: model.players.count,
                                          forGameCount: forGameCount.count))
      tableViewModels.append(.divider)
    }
    
    model.players.reversed().forEach {
      playersCount += appearance.increase
      tableViewModels.append(.player(player: $0, teamsCount: model.teamsCount))
      
      if playersCount != model.players.count {
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
