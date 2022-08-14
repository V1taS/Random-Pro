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
  
  /// Обновить контент
  ///  - Parameter models: Модели игроков
  func updateContentWith<T: PlayerProtocol>(models: [T])
  
  /// Добавить игрока
  ///  - Parameter name: Имя игрока
  func playerAdd(name: String?)
}

/// Интерактор
final class ListPlayersScreenInteractor: ListPlayersScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private var models: [ListPlayersScreenModel.Player] = []
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didRecive(models: models)
  }
  
  func updateContentWith<T>(models: [T]) where T : PlayerProtocol {
    if let models = models as? [ListPlayersScreenModel.Player] {
      self.models = models
    }
    output?.didRecive(models: self.models)
  }
  
  func playerAdd(name: String?) {
    guard let name = name else {
      return
    }
    
    let player = ListPlayersScreenModel.Player(
      name: name,
      avatar: generationImagePlayer()?.pngData(),
      emoji: nil,
      state: .random
    )
    models.append(player)
    output?.didRecive(models: models)
  }
}

// MARK: - Private

private extension ListPlayersScreenInteractor {
  func generationImagePlayer() -> UIImage? {
    let randomNumberPlayers = Int.random(in: Appearance().rangeImagePlayer)
    return UIImage(named: "player\(randomNumberPlayers)")
  }
}

// MARK: - Appearance

private extension ListPlayersScreenInteractor {
  struct Appearance {
    let rangeImagePlayer = 1...15
  }
}
