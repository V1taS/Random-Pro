//
//  MemesScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol MemesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol MemesScreenFactoryInput {}

/// Фабрика
final class MemesScreenFactory: MemesScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MemesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension MemesScreenFactory {
  struct Appearance {}
}
