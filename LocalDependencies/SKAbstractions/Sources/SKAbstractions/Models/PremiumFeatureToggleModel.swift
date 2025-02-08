//
//  PremiumFeatureToggleModel.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public struct PremiumFeatureToggleModel: Codable, Equatable {

  /// Уникальное ID устройства
  public let id: String?

  /// Включен ли Премиум
  public let isPremium: Bool?

  /// Имя
  public let name: String?

  /// Публичный инициализатор для PremiumFeatureToggleModel
  public init(id: String? = nil, isPremium: Bool? = nil, name: String? = nil) {
    self.id = id
    self.isPremium = isPremium
    self.name = name
  }
}
