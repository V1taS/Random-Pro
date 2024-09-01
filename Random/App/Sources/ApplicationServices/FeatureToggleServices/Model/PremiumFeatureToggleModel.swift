//
//  PremiumFeatureToggleModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct PremiumFeatureToggleModel: Codable, Equatable {
  
  /// Уникальное ID устройства
  let id: String?
  
  /// Включен ли Премиум
  let isPremium: Bool?
  
  /// Имя
  let name: String?
}
