//
//  ImageFiltersScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ImageFiltersScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ImageFiltersScreenFactoryInput {}

/// Фабрика
final class ImageFiltersScreenFactory: ImageFiltersScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ImageFiltersScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ImageFiltersScreenFactory {
  struct Appearance {}
}
