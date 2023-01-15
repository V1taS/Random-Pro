//
//  PremiumScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol PremiumScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol PremiumScreenFactoryInput {}

/// Фабрика
final class PremiumScreenFactory: PremiumScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension PremiumScreenFactory {
  struct Appearance {}
}
