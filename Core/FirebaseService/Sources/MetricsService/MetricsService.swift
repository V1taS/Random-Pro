//
//  MetricsService.swift
//  MetricsService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import YandexMobileMetrica
import FirebaseAnalytics

public final class MetricsServiceImpl: MetricsServiceProtocol {
  
  public init() {}
  
  // MARK: - Public func
  
  public func track(event: MetricsSectionsProtocol) {
    guard let event = event as? MetricsSections else {
      return
    }
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  public func track(event: MetricsSectionsProtocol, properties: [String: String]) {
    guard let event = event as? MetricsSections else {
      return
    }
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
