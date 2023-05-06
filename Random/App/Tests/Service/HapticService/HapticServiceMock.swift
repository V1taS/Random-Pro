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
  func play(isRepeat: Bool,
            patternType: HapticServiceImpl.PatternType,
            completion: (Result<Void, HapticServiceImpl.HapticError>) -> Void) {}
  
  func stop() {}
}
