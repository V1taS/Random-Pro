//
//  BottleStyleSelectionFactory.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol BottleStyleSelectionFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol BottleStyleSelectionFactoryInput {}

/// Фабрика
final class BottleStyleSelectionFactory: BottleStyleSelectionFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: BottleStyleSelectionFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension BottleStyleSelectionFactory {
  struct Appearance {}
}
