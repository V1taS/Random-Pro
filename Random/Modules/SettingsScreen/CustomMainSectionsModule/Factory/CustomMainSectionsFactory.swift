//
//  CustomMainSectionsFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol CustomMainSectionsFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol CustomMainSectionsFactoryInput {}

/// Фабрика
final class CustomMainSectionsFactory: CustomMainSectionsFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: CustomMainSectionsFactoryOutput?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension CustomMainSectionsFactory {
  struct Appearance {}
}
