//
//  MetricsServiceModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public struct MetricsServiceModel {

  /// Тип
  public let type: MetricsSections

  /// Количество нажатий
  public let countTapped: Int

  /// Публичный инициализатор для MetricsServiceModel
  public init(type: MetricsSections, countTapped: Int) {
    self.type = type
    self.countTapped = countTapped
  }
}
