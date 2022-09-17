//
//  UpdateAppScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol UpdateAppScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol UpdateAppScreenInteractorInput {}

/// Интерактор
final class UpdateAppScreenInteractor: UpdateAppScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: UpdateAppScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension UpdateAppScreenInteractor {
  struct Appearance {
    
  }
}
