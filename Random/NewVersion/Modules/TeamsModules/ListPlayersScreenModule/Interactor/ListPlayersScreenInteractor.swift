//
//  ListPlayersScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ListPlayersScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(models: [ListPlayersScreenModel.Player])
}

/// События которые отправляем от Presenter к Interactor
protocol ListPlayersScreenInteractorInput {
  
  /// Получить данные
  func getContent()
}

/// Интерактор
final class ListPlayersScreenInteractor: ListPlayersScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func getContent() {
    var models: [ListPlayersScreenModel.Player] = []
    
    for _ in 1...5 {
      let player = ListPlayersScreenModel.Player(
        name: "Сосин Виталий",
        avatar: UIImage(named: "player1")?.pngData(),
        emoji: "🔥",
        state: .teamTwo
      )
      models.append(player)
    }
    output?.didRecive(models: models)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenInteractor {
  struct Appearance {
    
  }
}
