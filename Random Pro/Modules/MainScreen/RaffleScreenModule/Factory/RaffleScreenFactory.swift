//
//  RaffleScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol RaffleScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol RaffleScreenFactoryInput {}

/// Фабрика
final class RaffleScreenFactory: RaffleScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: RaffleScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension RaffleScreenFactory {
  struct Appearance {}
}
