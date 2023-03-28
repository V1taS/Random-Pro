//
//  TeamsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из Interactor в Presenter
protocol TeamsScreenInteractorOutput: AnyObject {
  
  /// Был получен пустой список сгенерированных команд
  func didReceiveEmptyListTeams()
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: TeamsScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter к Interactor
protocol TeamsScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Обновить контент
  ///  - Parameter models: Модели игроков
  func updateContentWith(players: [TeamsScreenPlayerModel])
  
  /// Обновить количество команд
  ///  - Parameter count: Количество команд
  func updateTeams(count: Int)
  
  /// Обновить список команд
  ///  - Parameter teams: Список команд
  func updateList(teams: [TeamsScreenModel.Team])
  
  /// Возвращает основную модель данных
  func returnModel() -> TeamsScreenModel
  
  /// Возвращает текущее количество команд
  func returnCountTeams() -> Int
  
  /// Возвращает список команд
  func returnListTeams() -> [TeamsScreenModel.Team]
  
  /// Возвращает сколько выбрано команд
  func returnSelectedTeam() -> Int
  
  /// Возвращает список игроков
  func returnListPlayers() -> [TeamsScreenPlayerModel]
  
  /// Количество сгенерированных игроков
  func returnGeneratedCountPlayers() -> Int
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Обновить стиль
  func updateStyle()
}

/// Интерактор
final class TeamsScreenInteractor: TeamsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: TeamsScreeStorageServiceProtocol
  private var teamsScreenModel: TeamsScreenModel? {
    get {
      storageService.getDataWith(key: Appearance().teamsScreenModelKeyUserDefaults,
                                 to: TeamsScreenModel.self)
    } set {
      storageService.saveData(newValue, key: Appearance().teamsScreenModelKeyUserDefaults)
    }
  }
  
  private var stylePlayerCard: PlayerCardSelectionScreenModel.StyleCard {
    guard let card = storageService.getDataWith(key: Appearance().playerCardSelectionModelKeyUserDefaults,
                                                to: [PlayerCardSelectionScreenModel].self)?.filter({
      $0.playerCardSelection
    }).first  else {
      return .defaultStyle
    }
    return card.style
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - storageService: Сервис хранения
  init(storageService: TeamsScreeStorageServiceProtocol) {
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func updateStyle() {
    guard let model = teamsScreenModel else {
      return
    }
    
    let allPlayers: [TeamsScreenPlayerModel] = model.allPlayers.map {
      return TeamsScreenPlayerModel(id: $0.id,
                                    name: $0.name,
                                    avatar: $0.avatar,
                                    emoji: $0.emoji,
                                    state: $0.state,
                                    style: stylePlayerCard)
    }
    
    let teams = model.teams.map { team in
      let playersTeam = team.players.map { playersTeam in
        return TeamsScreenPlayerModel(id: playersTeam.id,
                                      name: playersTeam.name,
                                      avatar: playersTeam.avatar,
                                      emoji: playersTeam.emoji,
                                      state: playersTeam.state,
                                      style: stylePlayerCard)
      }
      return TeamsScreenModel.Team(name: team.name,
                                   players: playersTeam)
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: model.selectedTeam,
      allPlayers: allPlayers,
      teams: teams
    )
    output?.didReceive(model: newModel)
  }
  
  func updateTeams(count: Int) {
    guard let model = teamsScreenModel else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: count,
      allPlayers: model.allPlayers,
      teams: model.teams
    )
    self.teamsScreenModel = newModel
  }
  
  func updateList(teams: [TeamsScreenModel.Team]) {
    guard let model = teamsScreenModel else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: model.selectedTeam,
      allPlayers: model.allPlayers,
      teams: teams
    )
    self.teamsScreenModel = newModel
  }
  
  func getContent() {
    if let model = teamsScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: generateFakePlayers(),
                                   teams: [])
      self.teamsScreenModel = model
      output?.didReceiveEmptyListTeams()
    }
  }
  
  func updateContentWith(players: [TeamsScreenPlayerModel]) {
    if let model = teamsScreenModel {
      let newModel = TeamsScreenModel(
        selectedTeam: model.selectedTeam,
        allPlayers: players,
        teams: model.teams
      )
      self.teamsScreenModel = newModel
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: generateFakePlayers(),
                                   teams: [])
      self.teamsScreenModel = model
    }
  }
  
  func returnCountTeams() -> Int {
    guard let model = teamsScreenModel else {
      return .zero
    }
    return model.teams.count
  }
  
  func returnGeneratedCountPlayers() -> Int {
    guard let model = teamsScreenModel else {
      return .zero
    }
    
    var generatedCountPlayers = 0
    
    model.teams.forEach {
      generatedCountPlayers += $0.players.count
    }
    return generatedCountPlayers
  }
  
  func returnListTeams() -> [TeamsScreenModel.Team] {
    guard let model = teamsScreenModel  else {
      return []
    }
    return model.teams
  }
  
  func returnListPlayers() -> [TeamsScreenPlayerModel] {
    guard let model = teamsScreenModel  else {
      return []
    }
    return model.allPlayers
  }
  
  func returnModel() -> TeamsScreenModel {
    if let model = teamsScreenModel {
      return model
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: [],
                                   teams: [])
      return model
    }
  }
  
  func returnSelectedTeam() -> Int {
    guard let model = teamsScreenModel else {
      return .zero
    }
    return model.selectedTeam
  }
  
  func cleanButtonAction() {
    guard let model = teamsScreenModel else {
      return
    }
    
    let modelAllPlayers = model.allPlayers
    let newModel = TeamsScreenModel(selectedTeam: model.selectedTeam,
                                    allPlayers: modelAllPlayers,
                                    teams: [])
    self.teamsScreenModel = newModel
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Private

private extension TeamsScreenInteractor {
  func generateFakePlayers() -> [TeamsScreenPlayerModel] {
    let secondStartApp = UserDefaults.standard.bool(forKey: Appearance().keySecondStartApp)
    
    guard !secondStartApp else {
      return []
    }
    UserDefaults.standard.set(true, forKey: Appearance().keySecondStartApp)
    
    return (1...16).map {
      let appearance = Appearance()
      if $0.isMultiple(of: 3) {
        let emojiList = ["🔥", "⭐️", "⚽️", "🤑"].shuffled()
        return TeamsScreenPlayerModel(id: UUID().uuidString,
                                      name: "\(appearance.player) - \($0)",
                                      avatar: generationImagePlayer(),
                                      emoji: emojiList.first,
                                      state: .teamTwo,
                                      style: stylePlayerCard)
      } else if $0.isMultiple(of: 16) {
        return TeamsScreenPlayerModel(id: UUID().uuidString,
                                      name: "\(appearance.player) - \($0)",
                                      avatar: generationImagePlayer(),
                                      emoji: "🔴",
                                      state: .doesNotPlay,
                                      style: stylePlayerCard)
      } else {
        return TeamsScreenPlayerModel(id: UUID().uuidString,
                                      name: "\(appearance.player) - \($0)",
                                      avatar: generationImagePlayer(),
                                      emoji: nil,
                                      state: .random,
                                      style: stylePlayerCard)
      }
    }
  }
  
  func generationImagePlayer() -> String {
    let appearance = Appearance()
    let genderRandom = Int.random(in: 0...1)
    
    if genderRandom == .zero {
      let randomNumberPlayers = Int.random(in: appearance.rangeImageMalePlayer)
      return "male_player\(randomNumberPlayers)"
    } else {
      let randomNumberPlayers = Int.random(in: appearance.rangeImageFemalePlayer)
      return "female_player\(randomNumberPlayers)"
    }
  }
}

// MARK: - Appearance

private extension TeamsScreenInteractor {
  struct Appearance {
    let selectedTeamDefault = 3
    let rangeImageMalePlayer = 1...15
    let rangeImageFemalePlayer = 1...21
    let player = NSLocalizedString("Игрок", comment: "")
    let keySecondStartApp = "team_screen_second_start_app_key"
    let teamsScreenModelKeyUserDefaults = "team_screen_user_defaults_key"
    let playerCardSelectionModelKeyUserDefaults = "player_card_selection_screen_user_defaults_key"
  }
}
