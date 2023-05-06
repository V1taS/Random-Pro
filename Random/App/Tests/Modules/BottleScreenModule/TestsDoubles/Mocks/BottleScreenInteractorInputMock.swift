//
//  BottleScreenInteractorInputMock.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 09.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random

final class BottleScreenInteractorInputMock: BottleScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: BottleScreenInteractorOutput?
  
  // MARK: - Флаги вызовов функция
  
  var isGeneratesBottleRotationTimeAction: Bool = false
  
  // MARK: - BottleScreenInteractorInput
  
  func generatesBottleRotationTimeAction() {
    isGeneratesBottleRotationTimeAction = true
  }
  
  func playHapticFeedback() {
    // MARK: - Добавить тесты
  }
  
  func stopHapticFeedback() {
    // MARK: - Добавить тесты
  }
}
