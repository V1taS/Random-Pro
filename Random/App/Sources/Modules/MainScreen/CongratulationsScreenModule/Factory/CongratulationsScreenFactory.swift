//
//  CongratulationsScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol CongratulationsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol CongratulationsScreenFactoryInput {}

/// Фабрика
final class CongratulationsScreenFactory: CongratulationsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: CongratulationsScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension CongratulationsScreenFactory {
  struct Appearance {}
}
