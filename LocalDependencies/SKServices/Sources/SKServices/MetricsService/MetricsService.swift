//
//  MetricsService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import YandexMobileMetrica
import SKAbstractions

public final class MetricsServiceImpl: MetricsService {
  public init() {}

  // MARK: - Internal func
  
  public func track(event: MetricsSections) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      // swiftlint:disable:next no_print
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  public func track(event: MetricsSections, properties: [String: String]) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      // swiftlint:disable:next no_print
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
