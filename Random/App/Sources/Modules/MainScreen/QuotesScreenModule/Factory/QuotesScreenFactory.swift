//
//  QuotesScreenFactory.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol QuotesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol QuotesScreenFactoryInput {}

/// Фабрика
final class QuotesScreenFactory: QuotesScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: QuotesScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension QuotesScreenFactory {
  struct Appearance {}
}
