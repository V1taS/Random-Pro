//
//  MetricsService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions
import AmplitudeSwift

public final class MetricsServiceImpl: MetricsService {
  private var amplitude: Amplitude?

  public static let shared = MetricsServiceImpl()

  private init() {}

  // MARK: - Internal func

  public func track(event: MetricsSections) {
    setupAmplitude()
    amplitude?.track(eventType: event.rawValue)
  }

  public func track(event: MetricsSections, properties: [String: String]) {
    setupAmplitude()
    amplitude?.track(eventType: event.rawValue, eventProperties: properties)
  }
}

private extension MetricsServiceImpl {
  func setupAmplitude() {
    if amplitude == nil && !SecretsAPI.amplitude.isEmpty {
      amplitude = Amplitude(configuration: Configuration(apiKey: SecretsAPI.amplitude))
    }
  }
}
