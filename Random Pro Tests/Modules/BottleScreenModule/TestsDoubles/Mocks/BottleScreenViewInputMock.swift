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
  
  // MARK: - Флаги вызовов функция
  
  var isStopBottleRotation: Bool = false
  var isTactileFeedbackBottleRotates: Bool = false
  var isResetPositionBottle: Bool = false
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
