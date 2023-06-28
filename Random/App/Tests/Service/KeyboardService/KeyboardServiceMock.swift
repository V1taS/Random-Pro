//
//  KeyboardServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class KeyboardServiceMock: KeyboardService {
  
  // Spy variables
  var keyboardHeightChangeActionCalled = false
  var keyboardRectChangeActionCalled = false
  
  // Stub variables
  var height: CGFloat?
  var rect: CGRect?
  
  var keyboardHeightChangeAction: ((CGFloat) -> Void)? {
    didSet {
      keyboardHeightChangeActionCalled = true
    }
  }
  
  var keyboardRectChangeAction: ((CGRect) -> Void)? {
    didSet {
      keyboardRectChangeActionCalled = true
    }
  }
  
  // Mocking keyboard appearance
  func simulateKeyboardAppearing(with height: CGFloat, rect: CGRect) {
    self.height = height
    self.rect = rect
    
    keyboardHeightChangeAction?(height)
    keyboardRectChangeAction?(rect)
  }
  
  // Mocking keyboard disappearance
  func simulateKeyboardDisappearing() {
    height = 0
    rect = .zero
    
    keyboardHeightChangeAction?(0)
    keyboardRectChangeAction?(.zero)
  }
}
