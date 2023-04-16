//
//  NumberScreenFactoryInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

/// Mock factory Input
final class NumberScreenFactoryInputMock: NumberScreenFactoryInput {
  
  // MARK: - Флаги вызовов функция
  
  var isClearGeneration: Bool = false
  var isReverse: Bool = false
  
  // MARK: - NumberScreenFactoryInput
  
  func clearGeneration(text: String?) {
    isClearGeneration = true
  }
  
  func reverse(listResult: [String]) {
    isReverse = true
  }
}
