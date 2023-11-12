//
//  SeriesScreenInteractor.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol SeriesScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol SeriesScreenInteractorInput {}

/// Интерактор
final class SeriesScreenInteractor: SeriesScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: SeriesScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension SeriesScreenInteractor {
  struct Appearance {}
}
