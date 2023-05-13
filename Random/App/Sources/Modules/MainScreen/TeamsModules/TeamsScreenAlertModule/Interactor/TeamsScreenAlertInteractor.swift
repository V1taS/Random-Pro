//
//  TeamsScreenAlertInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol TeamsScreenAlertInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol TeamsScreenAlertInteractorInput {}

/// Интерактор
final class TeamsScreenAlertInteractor: TeamsScreenAlertInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenAlertInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension TeamsScreenAlertInteractor {
  struct Appearance {}
}
