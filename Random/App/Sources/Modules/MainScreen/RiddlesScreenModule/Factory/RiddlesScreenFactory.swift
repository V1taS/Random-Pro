//
//  RiddlesScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol RiddlesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol RiddlesScreenFactoryInput {}

/// Фабрика
final class RiddlesScreenFactory: RiddlesScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: RiddlesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension RiddlesScreenFactory {
  struct Appearance {}
}
