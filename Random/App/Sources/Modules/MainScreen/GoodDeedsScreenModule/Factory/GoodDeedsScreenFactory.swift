//
//  GoodDeedsScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol GoodDeedsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol GoodDeedsScreenFactoryInput {}

/// Фабрика
final class GoodDeedsScreenFactory: GoodDeedsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: GoodDeedsScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension GoodDeedsScreenFactory {
  struct Appearance {}
}
