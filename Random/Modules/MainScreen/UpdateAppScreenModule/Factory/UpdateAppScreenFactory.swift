//
//  UpdateAppScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol UpdateAppScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol UpdateAppScreenFactoryInput {}

/// Фабрика
final class UpdateAppScreenFactory: UpdateAppScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: UpdateAppScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension UpdateAppScreenFactory {
  struct Appearance {}
}
