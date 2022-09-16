//
//  CubesScreenFactory.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol CubesScreenFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol CubesScreenFactoryInput {
  
  /// Перевернуть список результатов
  ///  - Parameter listResult: Список результатов
  func reverseListResult(_ listResult: [String]) -> [String]
}

final class CubesScreenFactory: CubesScreenFactoryInput {
  
  // MARK: Internal property
  
  weak var output: CubesScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func reverseListResult(_ listResult: [String]) -> [String] {
    listResult.reversed()
  }
}
