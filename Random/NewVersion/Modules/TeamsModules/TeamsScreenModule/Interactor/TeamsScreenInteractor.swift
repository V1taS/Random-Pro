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
}

// MARK: - Appearance

private extension TeamsScreenInteractor {
  struct Appearance {
    
  }
}
