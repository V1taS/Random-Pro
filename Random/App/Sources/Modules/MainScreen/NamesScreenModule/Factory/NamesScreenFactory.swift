//
//  NamesScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol NamesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol NamesScreenFactoryInput {}

/// Фабрика
final class NamesScreenFactory: NamesScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: NamesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension NamesScreenFactory {
  struct Appearance {}
}
