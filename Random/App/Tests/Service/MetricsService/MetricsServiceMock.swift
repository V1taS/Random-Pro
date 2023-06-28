//
//  MetricsServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class MetricsServiceMock: MetricsService {
  
  // Spy variables
  var trackCalled = false
  var trackWithPropertiesCalled = false
  
  // Stub variables
  var event: Random.MetricsSections?
  var properties: [String : String]?
  
  func track(event: Random.MetricsSections) {
    trackCalled = true
    self.event = event
  }
  
  func track(event: Random.MetricsSections, properties: [String : String]) {
    trackWithPropertiesCalled = true
    self.event = event
    self.properties = properties
  }
}
