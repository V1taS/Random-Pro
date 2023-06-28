//
//  HapticServiceMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 17.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class HapticServiceMock: HapticService {
  
  // Spy variables
  var playCalled = false
  var stopCalled = false
  
  // Stub variables
  var playResult: Result<Void, HapticServiceImpl.HapticError> = .failure(.notSupported)
  
  func play(isRepeat: Bool,
            patternType: HapticServiceImpl.PatternType,
            completion: (Result<Void, HapticServiceImpl.HapticError>) -> Void) {
    playCalled = true
    completion(playResult)
  }
  
  func stop() {
    stopCalled = true
  }
}
