//
//  SlogansScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol SlogansScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol SlogansScreenFactoryInput {}

/// Фабрика
final class SlogansScreenFactory: SlogansScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SlogansScreenFactoryOutput?
}

// MARK: - Appearance

private extension SlogansScreenFactory {
  struct Appearance {}
}
