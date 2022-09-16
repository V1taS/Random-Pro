//
//  ListResultScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ListResultScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ListResultScreenFactoryInput {}

/// Фабрика
final class ListResultScreenFactory: ListResultScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ListResultScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ListResultScreenFactory {
  struct Appearance {}
}
