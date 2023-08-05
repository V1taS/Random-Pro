//
//  AppUnavailableFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol AppUnavailableFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol AppUnavailableFactoryInput {}

/// Фабрика
final class AppUnavailableFactory: AppUnavailableFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: AppUnavailableFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension AppUnavailableFactory {
  struct Appearance {}
}
