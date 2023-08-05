//
//  ForceUpdateAppInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ForceUpdateAppInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol ForceUpdateAppInteractorInput {}

/// Интерактор
final class ForceUpdateAppInteractor: ForceUpdateAppInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: ForceUpdateAppInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ForceUpdateAppInteractor {
  struct Appearance {}
}
