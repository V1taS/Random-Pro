//
//  ButtonCounterServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class ButtonCounterServiceMock: ButtonCounterService {
  
  // Spy variable
  var onButtonClickCalled = false
  
  // Stub variable
  var clickResponse: ((Int) -> Void)?
  var clickCount = 0
  
  func onButtonClick() {
    onButtonClickCalled = true
    clickCount += 1
    clickResponse?(clickCount)
  }
}
