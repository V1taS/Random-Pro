//
//  TruthOrDareScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol TruthOrDareScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol TruthOrDareScreenFactoryInput {}

/// Фабрика
final class TruthOrDareScreenFactory: TruthOrDareScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: TruthOrDareScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension TruthOrDareScreenFactory {
  struct Appearance {}
}
