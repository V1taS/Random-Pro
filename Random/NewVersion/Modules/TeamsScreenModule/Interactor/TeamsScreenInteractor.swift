//
//  TeamsScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol TeamsScreenInteractorOutput: AnyObject {
  
}

/// События которые отправляем от Presenter к Interactor
protocol TeamsScreenInteractorInput {
  
}

/// Интерактор
final class TeamsScreenInteractor: TeamsScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenInteractorOutput?
  
  // MARK: - Internal func
  
}

// MARK: - Appearance

private extension TeamsScreenInteractor {
  struct Appearance {
    
  }
}
