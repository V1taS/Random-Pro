//
//  BottleScreenViewInputMock.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 09.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random_Pro

final class BottleScreenViewInputMock: BottleScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: BottleScreenViewOutput?
  
  // MARK: - Флаги вызовов функция
  
  var isStopBottleRotation: Bool = false
  var isTactileFeedbackBottleRotates: Bool = false
  var isResetPositionBottle: Bool = false
  
  // MARK: - BottleScreenViewInput
  
  func stopBottleRotation() {
    isStopBottleRotation = true
  }
  
  func tactileFeedbackBottleRotates() {
    isTactileFeedbackBottleRotates = true
  }
  
  func resetPositionBottle() {
    isResetPositionBottle = true
  }
}
