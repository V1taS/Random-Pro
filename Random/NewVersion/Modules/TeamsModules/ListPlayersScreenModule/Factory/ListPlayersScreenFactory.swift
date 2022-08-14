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
  ///  - Parameter model: результат генерации для таблички
  func didRecive(model: [ListPlayersScreenType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ListPlayersScreenFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameter listResult: массив результатов
  func createListModelFrom(players: [ListPlayersScreenModel.Player])
}

/// Фабрика
final class ListPlayersScreenFactory: ListPlayersScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelFrom(players: [ListPlayersScreenModel.Player]) {
    var model: [ListPlayersScreenType] = []
    var playersCount = 0
    
    model.append(.insets(16))
    model.append(.textField)
    model.append(.insets(16))
    
    if !players.isEmpty {
      model.append(.divider)
    }
    
    players.reversed().forEach {
      playersCount += 1
      model.append(.player($0))
      
      if playersCount != players.count {
        model.append(.divider)
      }
    }
    output?.didRecive(model: model)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenFactory {
  struct Appearance {
    
  }
}
