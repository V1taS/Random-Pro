//
//  NamesNewScreenFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import SwiftUI

/// Cобытия которые отправляем из Factory в Presenter
protocol NamesNewScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol NamesNewScreenFactoryInput {}

/// Фабрика
final class NamesNewScreenFactory {
  
  // MARK: - Internal properties
  
  weak var output: NamesNewScreenFactoryOutput?
}

// MARK: - NamesNewScreenFactoryInput

extension NamesNewScreenFactory: NamesNewScreenFactoryInput {}

// MARK: - Private

private extension NamesNewScreenFactory {}

// MARK: - Constants

private enum Constants {}
