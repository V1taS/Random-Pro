//
//  TeamsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol TeamsScreenFactoryOutput: AnyObject {
  
}

/// Cобытия которые отправляем от Presenter к Factory
protocol TeamsScreenFactoryInput {
  
}

/// Фабрика
final class TeamsScreenFactory: TeamsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenFactoryOutput?
  
  // MARK: - Internal func
  
}

// MARK: - Appearance

private extension TeamsScreenFactory {
  struct Appearance {
    
  }
}
