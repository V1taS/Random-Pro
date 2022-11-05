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
  
  @ObjectCustomUserDefaultsWrapper<TeamsScreenModel>(key: Appearance().keyUserDefaults)
  private var model: TeamsScreenModel?
  
  // MARK: - Internal func
  
  func updateTeams(count: Int) {
    guard let model = model else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: count,
      allPlayers: model.allPlayers,
      teams: model.teams
    )
    self.model = newModel
  }
  
  func updateList(teams: [TeamsScreenModel.Team]) {
    guard let model = model else {
      return
    }
    
    let newModel = TeamsScreenModel(
      selectedTeam: model.selectedTeam,
      allPlayers: model.allPlayers,
      teams: teams
    )
    self.model = newModel
  }
  
  func getContent() {
    if let model = model {
      output?.didReceive(model: model)
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: [],
                                   teams: [])
      self.model = model
      output?.didReceiveEmptyListTeams()
    }
  }
  
  func updateContentWith(players: [TeamsScreenPlayerModel]) {
    if let model = model {
      let newModel = TeamsScreenModel(
        selectedTeam: model.selectedTeam,
        allPlayers: players,
        teams: model.teams
      )
      self.model = newModel
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: [],
                                   teams: [])
      self.model = model
    }
  }
  
  func returnCountTeams() -> Int {
    guard let model = model else {
      return .zero
    }
    return model.teams.count
  }
  
  func returnGeneratedCountPlayers() -> Int {
    guard let model = model else {
      return .zero
    }
    
    var generatedCountPlayers = 0
    
    model.teams.forEach {
      generatedCountPlayers += $0.players.count
    }
    return generatedCountPlayers
  }
  
  func returnListTeams() -> [TeamsScreenModel.Team] {
    guard let model = model else {
      return []
    }
    return model.teams
  }
  
  func returnListPlayers() -> [TeamsScreenPlayerModel] {
    guard let model = model else {
      return []
    }
    return model.allPlayers
  }
  
  func returnModel() -> TeamsScreenModel {
    if let model = model {
      return model
    } else {
      let model = TeamsScreenModel(selectedTeam: Appearance().selectedTeamDefault,
                                   allPlayers: [],
                                   teams: [])
      return model
    }
  }
  
  func returnSelectedTeam() -> Int {
    guard let model = model else {
      return .zero
    }
    return model.selectedTeam
  }
  
  func cleanButtonAction() {
    guard let model = model else {
      return
    }
    let newModel = TeamsScreenModel(selectedTeam: model.selectedTeam,
                                    allPlayers: model.allPlayers,
                                    teams: [])
    self.model = newModel
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Appearance

private extension TeamsScreenInteractor {
  struct Appearance {
    let selectedTeamDefault = 2
    let keyUserDefaults = "team_screen_user_defaults_key"
  }
}
