//
//  NickNameScreenFactory.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol NickNameScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol NickNameScreenFactoryInput {}

/// Фабрика
final class NickNameScreenFactory: NickNameScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: NickNameScreenFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension NickNameScreenFactory {
  struct Appearance {}
}
