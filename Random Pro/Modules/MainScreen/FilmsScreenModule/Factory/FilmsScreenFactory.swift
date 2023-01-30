//
//  FilmsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol FilmsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FilmsScreenFactoryInput {}

/// Фабрика
final class FilmsScreenFactory: FilmsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FilmsScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension FilmsScreenFactory {
  struct Appearance {}
}
