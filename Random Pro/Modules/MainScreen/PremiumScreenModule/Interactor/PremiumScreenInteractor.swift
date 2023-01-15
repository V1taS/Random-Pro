//
//  PremiumScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol PremiumScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol PremiumScreenInteractorInput {}

/// Интерактор
final class PremiumScreenInteractor: PremiumScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension PremiumScreenInteractor {
  struct Appearance {}
}
