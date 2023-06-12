//
//  GiftsScreenFactory.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import Foundation

/// Cобытия которые отправляем из Factory в Presenter
protocol GiftsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol GiftsScreenFactoryInput {}

/// Фабрика
final class GiftsScreenFactory: GiftsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: GiftsScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension GiftsScreenFactory {
  struct Appearance {}
}
