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
    
    players.forEach {
      model.append(.player($0))
    }
    
    model.append(.textField("Плейсхолдер"))
    output?.didRecive(model: model)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenFactory {
  struct Appearance {
    
  }
}
