//
//  MetricsService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol MetricsService {

  /// Отправляем стандартную метрику
  ///  - Parameter event: Выбираем метрику
  func track(event: MetricsSections)

  /// Отправляем метрику и дополнительную информацию в словаре `[String : String]`
  /// - Parameters:
  ///  - event: Выбираем метрику
  ///  - properties: Словарик с дополнительной информацией `[String : String]`
  func track(event: MetricsSections, properties: [String: String])
}
