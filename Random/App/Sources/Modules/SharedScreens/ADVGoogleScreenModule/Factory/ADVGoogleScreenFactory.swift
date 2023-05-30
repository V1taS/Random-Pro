//
//  ADVGoogleScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ADVGoogleScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ADVGoogleScreenFactoryInput {}

/// Фабрика
final class ADVGoogleScreenFactory: ADVGoogleScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ADVGoogleScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ADVGoogleScreenFactory {
  struct Appearance {}
}
