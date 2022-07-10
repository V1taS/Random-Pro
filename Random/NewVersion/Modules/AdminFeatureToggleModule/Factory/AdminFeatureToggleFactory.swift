//
//  AdminFeatureToggleFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol AdminFeatureToggleFactoryOutput: AnyObject {
  
}

/// Cобытия которые отправляем от Presenter к Factory
protocol AdminFeatureToggleFactoryInput {
  
}

/// Фабрика
final class AdminFeatureToggleFactory: AdminFeatureToggleFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: AdminFeatureToggleFactoryOutput?
  
  // MARK: - Internal func
  
}

// MARK: - Appearance

private extension AdminFeatureToggleFactory {
  struct Appearance {
    
  }
}
