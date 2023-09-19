//
//  CoinStyleSelectionScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol CoinStyleSelectionScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol CoinStyleSelectionScreenFactoryInput {}

/// Фабрика
final class CoinStyleSelectionScreenFactory: CoinStyleSelectionScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: CoinStyleSelectionScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenFactory {
  struct Appearance {}
}
