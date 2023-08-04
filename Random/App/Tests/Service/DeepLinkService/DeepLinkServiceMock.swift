//
//  DeepLinkServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class DeepLinkServiceMock: DeepLinkService {
  
  // Spy variables
  var eventHandlingWithCalled = false
  
  // Stub variables
  var deepLinkTypeStub: Random.DeepLinkType?
  
  func eventHandlingWith(deepLimkURL: URL?) {
    eventHandlingWithCalled = true
  }
  
  var deepLinkType: Random.DeepLinkType? {
    get {
      return deepLinkTypeStub
    }
    set {
      deepLinkTypeStub = newValue
    }
  }
  
  var dynamicLinkType: Random.DynamicLinkType? = nil
}
