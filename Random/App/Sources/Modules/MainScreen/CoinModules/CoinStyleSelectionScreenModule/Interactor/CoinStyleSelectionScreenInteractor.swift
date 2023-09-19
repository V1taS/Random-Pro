//
//  CoinStyleSelectionScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol CoinStyleSelectionScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol CoinStyleSelectionScreenInteractorInput {}

/// Интерактор
final class CoinStyleSelectionScreenInteractor: CoinStyleSelectionScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: CoinStyleSelectionScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenInteractor {
  struct Appearance {}
}
