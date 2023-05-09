//
//  ColorsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ColorsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ColorsScreenFactoryInput {}

/// Фабрика
final class ColorsScreenFactory: ColorsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ColorsScreenFactoryOutput?
}

// MARK: - Appearance

private extension ColorsScreenFactory {
  struct Appearance {}
}
