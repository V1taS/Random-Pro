//
//  MetricsService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 05.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Foundation
import YandexMobileMetrica

protocol MetricsService {
  
  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsSections)
  
  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsSections, properties: [String: String])
}

final class MetricsServiceImpl: MetricsService {
  func track(event: MetricsSections) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String : String]) {
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}
