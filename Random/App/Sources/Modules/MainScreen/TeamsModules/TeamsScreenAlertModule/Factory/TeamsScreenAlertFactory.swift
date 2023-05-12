//
//  TeamsScreenAlertFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol TeamsScreenAlertFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol TeamsScreenAlertFactoryInput {}

/// Фабрика
final class TeamsScreenAlertFactory: TeamsScreenAlertFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: TeamsScreenAlertFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension TeamsScreenAlertFactory {
  struct Appearance {}
}
