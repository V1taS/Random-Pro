//
//  CubesStyleSelectionScreenFactory.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol CubesStyleSelectionScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol CubesStyleSelectionScreenFactoryInput {}

/// Фабрика
final class CubesStyleSelectionScreenFactory: CubesStyleSelectionScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: CubesStyleSelectionScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenFactory {
  struct Appearance {}
}
