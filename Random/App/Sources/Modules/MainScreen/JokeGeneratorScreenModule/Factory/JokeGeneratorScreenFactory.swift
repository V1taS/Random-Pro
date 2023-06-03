//
//  JokeGeneratorScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol JokeGeneratorScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol JokeGeneratorScreenFactoryInput {}

/// Фабрика
final class JokeGeneratorScreenFactory: JokeGeneratorScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: JokeGeneratorScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension JokeGeneratorScreenFactory {
  struct Appearance {}
}
