//
//  ShareScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ShareScreenFactoryOutput: AnyObject {
  
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ShareScreenFactoryInput {
  
}

/// Фабрика
final class ShareScreenFactory: ShareScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ShareScreenFactoryOutput?
  
  // MARK: - Internal func
  
}

// MARK: - Appearance

private extension ShareScreenFactory {
  struct Appearance {
    
  }
}
