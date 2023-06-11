//
//  FortuneWheelFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomWheel

/// Cобытия которые отправляем из Factory в Presenter
protocol FortuneWheelFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FortuneWheelFactoryInput {}

/// Фабрика
final class FortuneWheelFactory: FortuneWheelFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension FortuneWheelFactory {
  struct Appearance {}
}
