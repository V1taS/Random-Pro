//
//  ListPlayersScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import RandomUIKit
import ApplicationInterface

/// События которые отправляем из Interactor в Presenter
protocol ListPlayersScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameters:
  ///   - players: Список игроков
  ///   - teamsCount: Количество команд
  func didReceive(players: [TeamsScreenPlayerModel], teamsCount: Int)
}

/// События которые отправляем от Presenter к Interactor
protocol ListPlayersScreenInteractorInput {
  
  /// Возвращает текущий список игроков
  func returnCurrentListPlayers() -> [TeamsScreenPlayerModel]
  
  /// Получить данные
  func getContent()
  
  /// Обновить контент
  ///  - Parameters:
  ///   - models: Модели игроков
  ///   - teamsCount: Общее количество игроков
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int)
  
  /// Обновить реакцию у игрока
  /// - Parameters:
  ///  - emoji: Реакция
  ///  - id: Уникальный номер игрока
  func updatePlayer(emoji: String, id: String)
  
  /// Обновить статус у игрока
  /// - Parameters:
  ///  - state: Статус игрока
  ///  - id: Уникальный номер игрока
  func updatePlayer(state: TeamsScreenPlayerModel.PlayerState, id: String)
  
  /// Добавить игрока
  ///  - Parameter name: Имя игрока
  func playerAdd(name: String?)
  
  /// Удалить игрока
  ///  - Parameter id: Уникальный номер игрока
  func playerRemove(id: String)
  
  /// Удалить всех игроков
  func removeAllPlayers()
  
  /// Пол игрока был изменен
  /// - Parameter index: Индекс пола игрока
  func genderValueChanged(_ index: Int)
}

/// Интерактор
final class ListPlayersScreenInteractor: ListPlayersScreenInteractorInput {

  // MARK: - Internal properties
  
  weak var output: ListPlayersScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private var models: [TeamsScreenPlayerModel] = []
  private var defaultTeamsCount = Appearance().defaultTeamsCount
  private var genderIndex = Appearance().genderMaleIndex
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
  ///   - storageService: Сервис хранения данных
  init(storageService: StorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int) {
    self.models = models
    defaultTeamsCount = teamsCount
  }
  
  func updatePlayer(emoji: String, id: String) {
    let index = models.firstIndex { $0.id == id }
    guard let index = index else {
      return
    }
    
    let player = TeamsScreenPlayerModel(
      id: models[index].id,
      name: models[index].name,
      avatar: models[index].avatar,
      emoji: emoji,
      state: (models[index].state as? TeamsScreenPlayerModel.PlayerState) ?? .random,
      style: stylePlayerCard
    )
    
    models.remove(at: index)
    models.insert(player, at: index)
    
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func updatePlayer(state: TeamsScreenPlayerModel.PlayerState, id: String) {
    let index = models.firstIndex { $0.id == id }
    guard let index = index else {
      return
    }
    
    let player = TeamsScreenPlayerModel(
      id: models[index].id,
      name: models[index].name,
      avatar: models[index].avatar,
      emoji: models[index].emoji,
      state: state,
      style: stylePlayerCard
    )
    
    models.remove(at: index)
    models.insert(player, at: index)
    
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func playerAdd(name: String?) {
    guard
      let name = name,
      !name.isEmpty
    else {
      return
    }
    
    let player = TeamsScreenPlayerModel(
      id: UUID().uuidString,
      name: name,
      avatar: generationImagePlayer(),
      emoji: nil,
      state: .random,
      style: stylePlayerCard
    )
    
    models.append(player)
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func playerRemove(id: String) {
    let index = models.firstIndex { $0.id == id }
    guard let index = index else {
      return
    }
    
    models.remove(at: index)
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func removeAllPlayers() {
    models = []
    output?.didReceive(players: models, teamsCount: defaultTeamsCount)
  }
  
  func returnCurrentListPlayers() -> [TeamsScreenPlayerModel] {
    return models
  }
  
  func genderValueChanged(_ index: Int) {
    genderIndex = index
  }
}

// MARK: - Private

private extension ListPlayersScreenInteractor {
  func generationImagePlayer() -> String {
    let appearance = Appearance()
    
    if genderIndex == appearance.genderMaleIndex {
      let randomNumberPlayers = Int.random(in: Appearance().rangeImageMalePlayer)
      return "male_player\(randomNumberPlayers)"
    } else {
      let randomNumberPlayers = Int.random(in: Appearance().rangeImageFemalePlayer)
      return "female_player\(randomNumberPlayers)"
    }
  }
}

// MARK: - Appearance

private extension ListPlayersScreenInteractor {
  struct Appearance {
    let rangeImageMalePlayer = 1...15
    let rangeImageFemalePlayer = 1...21
    let defaultTeamsCount = 2
    let genderMaleIndex = 0
    let genderFemaleIndex = 1
  }
}
