//
//  ForceUpdateAppFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol ForceUpdateAppFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ForceUpdateAppFactoryInput {}

/// Фабрика
final class ForceUpdateAppFactory: ForceUpdateAppFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ForceUpdateAppFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ForceUpdateAppFactory {
  struct Appearance {}
}
