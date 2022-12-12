//
//  RockPaperScissorsScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol RockPaperScissorsScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol RockPaperScissorsScreenFactoryInput {}

final class RockPaperScissorsScreenFactory: RockPaperScissorsScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: RockPaperScissorsScreenFactoryOutput?
}
