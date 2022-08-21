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
  func didRecive(model: ListPlayersScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol ListPlayersScreenInteractorInput {
  
  /// Возвращает текущий список игроков
  func returnCurrentListPlayers() -> [ListPlayersScreenModel.Player]
  
  /// Получить данные
  func getContent()
  
  /// Обновить контент
  ///  - Parameters:
  ///   - models: Модели игроков
  ///   - teamsCount: Общее количество игроков
  func updateContentWith<T: PlayerProtocol>(models: [T], teamsCount: Int)
  
  /// Обновить реакцию у игрока
  /// - Parameters:
  ///  - emoji: Реакция
  ///  - id: Уникальный номер игрока
  func updatePlayer(emoji: String, id: String)
  
  /// Обновить статус у игрока
  /// - Parameters:
  ///  - state: Статус игрока
  ///  - id: Уникальный номер игрока
  func updatePlayer(state: ListPlayersScreenModel.PlayerState, id: String)
  
  /// Добавить игрока
  ///  - Parameter name: Имя игрока
  func playerAdd(name: String?)
  
  /// Удалить игрока
  ///  - Parameter id: Уникальный номер игрока
  func playerRemove(id: String)
  
  /// Удалить всех игроков
  func removeAllPlayers()
}

/// Интерактор
final class ListPlayersScreenInteractor: ListPlayersScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private var model: ListPlayersScreenModel?
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = model {
      output?.didRecive(model: model)
    } else {
      let model = ListPlayersScreenModel(players: [], teamsCount: Appearance().defaultTeamsCount)
      self.model = model
      output?.didRecive(model: model)
    }
  }
  
  func updateContentWith<T: PlayerProtocol>(models: [T], teamsCount: Int) {
    if let players = models as? [ListPlayersScreenModel.Player] {
      let model = ListPlayersScreenModel(players: players, teamsCount: teamsCount)
      self.model = model
      output?.didRecive(model: model)
    }
  }
  
  func updatePlayer(emoji: String, id: String) {
    guard let model = model else {
      return
    }
    
    let index = model.players.firstIndex{ $0.id == id }
    guard let index = index else {
      return
    }
    
    var players = model.players
    let player = ListPlayersScreenModel.Player(
      name: players[index].name,
      avatar: players[index].avatar,
      emoji: emoji,
      state: players[index].state
    )
    
    players.remove(at: index)
    players.insert(player, at: index)
    
    let newModel = ListPlayersScreenModel(players: players, teamsCount: model.teamsCount)
    self.model = newModel
    output?.didRecive(model: newModel)
  }
  
  func updatePlayer(state: ListPlayersScreenModel.PlayerState, id: String) {
    guard let model = model else {
      return
    }
    
    let index = model.players.firstIndex{ $0.id == id }
    guard let index = index else {
      return
    }
    
    var players = model.players
    let player = ListPlayersScreenModel.Player(
      name: players[index].name,
      avatar: players[index].avatar,
      emoji: players[index].emoji,
      state: state
    )
    
    players.remove(at: index)
    players.insert(player, at: index)
    
    let newModel = ListPlayersScreenModel(players: players, teamsCount: model.teamsCount)
    self.model = newModel
    output?.didRecive(model: newModel)
  }
  
  func playerAdd(name: String?) {
    guard
      let name = name,
      !name.isEmpty
    else {
      return
    }
    
    var players: [ListPlayersScreenModel.Player] = self.model?.players ?? []
    let player = ListPlayersScreenModel.Player(
      name: name,
      avatar: generationImagePlayer()?.pngData(),
      emoji: "⚪️",
      state: .random
    )
    
    players.append(player)
    let model = ListPlayersScreenModel(players: players,
                                       teamsCount: self.model?.teamsCount ?? Appearance().defaultTeamsCount)
    self.model = model
    output?.didRecive(model: model)
  }
  
  func playerRemove(id: String) {
    guard let model = model else {
      return
    }
    
    let index = model.players.firstIndex{ $0.id == id }
    guard let index = index else {
      return
    }
    
    var players = model.players
    players.remove(at: index)
    
    let newModel = ListPlayersScreenModel(players: players, teamsCount: model.teamsCount)
    self.model = newModel
    output?.didRecive(model: newModel)
  }
  
  func removeAllPlayers() {
    if let model = model {
      let model = ListPlayersScreenModel(players: [], teamsCount: model.teamsCount)
      self.model = model
      output?.didRecive(model: model)
    } else {
      let model = ListPlayersScreenModel(players: [], teamsCount: Appearance().defaultTeamsCount)
      self.model = model
      output?.didRecive(model: model)
    }
  }
  
  func returnCurrentListPlayers() -> [ListPlayersScreenModel.Player] {
    if let model = model {
      return model.players
    } else {
      return []
    }
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
    let defaultTeamsCount = 2
  }
}
