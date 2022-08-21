//
//  TeamsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol TeamsScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: TeamsScreenModel)
}

/// События которые отправляем от Presenter к Interactor
protocol TeamsScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Обновить контент
  ///  - Parameter models: Модели игроков
  func updateContentWith<T: PlayerProtocol>(models: [T])
  
  /// Возвращает текущее количество команд
  func returnGeneratedCountTeams() -> Int
  
  /// Количество сгенерированных игроков
  func returnGeneratedCountPlayers() -> Int
  
  /// Возвращает список команд
  func returnListTeams() -> [TeamsScreenModel.Team]
}

/// Интерактор
final class TeamsScreenInteractor: TeamsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenInteractorOutput?
  
  // MARK: - Internal func
  
  func getContent() {
    let model = TeamsScreenModel(selectedTeam: .zero, allPlayers: [], teams: [])
    output?.didRecive(model: model)
  }
  
  func updateContentWith<T: PlayerProtocol>(models: [T]) {
    // TODO: -
  }
  
  func returnGeneratedCountTeams() -> Int {
    // TODO: -
    return 5
  }
  
  func returnGeneratedCountPlayers() -> Int {
    return 2
  }
  
  func returnListTeams() -> [TeamsScreenModel.Team] {
    // TODO: -
    return []
  }
}

// MARK: - Appearance

private extension TeamsScreenInteractor {
  struct Appearance {
    
  }
}
