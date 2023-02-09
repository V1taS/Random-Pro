//
//  TeamsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

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
}

/// Интерактор
final class TeamsScreenInteractor: TeamsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenInteractorOutput?
  
  // MARK: - Private property
  
  private var storageService: StorageService
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - services: Сервисы приложения
  init(services: ApplicationServices) {
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func updateTeams(count: Int) {
    guard let model = storageService.teamsScreenModel else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: count,
      allPlayers: model.allPlayers,
      teams: model.teams
    )
    self.storageService.teamsScreenModel = newModel
  }
  
  func updateList(teams: [TeamsScreenModel.Team]) {
    guard let model = storageService.teamsScreenModel else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: model.selectedTeam,
      allPlayers: model.allPlayers,
      teams: teams
    )
    self.storageService.teamsScreenModel = newModel
  }
  
  func getContent() {
    if let model = storageService.teamsScreenModel {
      output?.didReceive(model: model)
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: generateFakePlayers(),
                                   teams: [])
      self.storageService.teamsScreenModel = model
      output?.didReceiveEmptyListTeams()
    }
  }
  
  func updateContentWith(players: [TeamsScreenPlayerModel]) {
    if let model = storageService.teamsScreenModel {
      let newModel = TeamsScreenModel(
        selectedTeam: model.selectedTeam,
        allPlayers: players,
        teams: model.teams
      )
      self.storageService.teamsScreenModel = newModel
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: generateFakePlayers(),
                                   teams: [])
      self.storageService.teamsScreenModel = model
    }
  }
  
  func returnCountTeams() -> Int {
    guard let model = storageService.teamsScreenModel else {
      return .zero
    }
    return model.teams.count
  }
  
  func returnGeneratedCountPlayers() -> Int {
    guard let model = storageService.teamsScreenModel else {
      return .zero
    }
    
    var generatedCountPlayers = 0
    
    model.teams.forEach {
      generatedCountPlayers += $0.players.count
    }
    return generatedCountPlayers
  }
  
  func returnListTeams() -> [TeamsScreenModel.Team] {
    guard let model = storageService.teamsScreenModel else {
      return []
    }
    return model.teams
  }
  
  func returnListPlayers() -> [TeamsScreenPlayerModel] {
    guard let model = storageService.teamsScreenModel else {
      return []
    }
    return model.allPlayers
  }
  
  func returnModel() -> TeamsScreenModel {
    if let model = storageService.teamsScreenModel {
      return model
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: [],
                                   teams: [])
      return model
    }
  }
  
  func returnSelectedTeam() -> Int {
    guard let model = storageService.teamsScreenModel else {
      return .zero
    }
    return model.selectedTeam
  }
  
  func cleanButtonAction() {
    guard let model = storageService.teamsScreenModel else {
      return
    }
    let newModel = TeamsScreenModel(selectedTeam: model.selectedTeam,
                                    allPlayers: model.allPlayers,
                                    teams: [])
    self.storageService.teamsScreenModel = newModel
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
                                      state: .teamTwo)
      } else if $0.isMultiple(of: 16) {
        return TeamsScreenPlayerModel(id: UUID().uuidString,
                                      name: "\(appearance.player) - \($0)",
                                      avatar: generationImagePlayer(),
                                      emoji: "🔴",
                                      state: .doesNotPlay)
      } else {
        return TeamsScreenPlayerModel(id: UUID().uuidString,
                                      name: "\(appearance.player) - \($0)",
                                      avatar: generationImagePlayer(),
                                      emoji: nil,
                                      state: .random)
      }
    }
  }
  
  func generationImagePlayer() -> Data? {
    let appearance = Appearance()
    let genderRandom = Int.random(in: 0...1)
    
    if genderRandom == .zero {
      let randomNumberPlayers = Int.random(in: appearance.rangeImageMalePlayer)
      return (UIImage(named: "male_player\(randomNumberPlayers)") ?? UIImage()).pngData()
    } else {
      let randomNumberPlayers = Int.random(in: appearance.rangeImageFemalePlayer)
      return (UIImage(named: "female_player\(randomNumberPlayers)") ?? UIImage()).pngData()
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
  }
}
