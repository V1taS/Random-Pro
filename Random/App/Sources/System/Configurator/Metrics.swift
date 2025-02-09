//
//  Metrics.swift
//  Random
//
//  Created by Vitalii Sosin on 9.02.2025.
//  Copyright © 2025 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions
import SKServices

final class Metrics {
  static let shared = Metrics()
  private init() {}

  func track(event: MetricsSections) {
    MetricsServiceImpl.shared.track(event: event)
  }

  func track(event: MetricsSections, properties: [String: String]) {
    MetricsServiceImpl.shared.track(event: event, properties: properties)
  }
}
