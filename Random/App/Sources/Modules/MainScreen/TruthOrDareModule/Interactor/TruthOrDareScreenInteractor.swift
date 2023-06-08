//
//  TruthOrDareScreenInteractor.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol TruthOrDareScreenInteractorOutput: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol TruthOrDareScreenInteractorInput {}

/// Интерактор
final class TruthOrDareScreenInteractor: TruthOrDareScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenInteractorOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension TruthOrDareScreenInteractor {
  struct Appearance {}
}
