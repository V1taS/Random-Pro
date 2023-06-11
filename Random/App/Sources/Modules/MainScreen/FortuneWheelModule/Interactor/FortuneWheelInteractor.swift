//
//  FortuneWheelInteractor.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol FortuneWheelInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol FortuneWheelInteractorInput {}

/// Интерактор
final class FortuneWheelInteractor: FortuneWheelInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension FortuneWheelInteractor {
  struct Appearance {}
}
