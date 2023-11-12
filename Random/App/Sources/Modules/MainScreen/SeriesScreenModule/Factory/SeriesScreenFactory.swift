//
//  SeriesScreenFactory.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol SeriesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol SeriesScreenFactoryInput {}

/// Фабрика
final class SeriesScreenFactory: SeriesScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SeriesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension SeriesScreenFactory {
  struct Appearance {}
}
