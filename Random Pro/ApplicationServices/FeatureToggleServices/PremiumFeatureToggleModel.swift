//
//  PremiumFeatureToggleModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct PremiumFeatureToggleModel {
  
  /// Уникальное ID устройства
  let id: String?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  init(dictionary: [String: Any]) {
    id = dictionary["id"] as? String
  }
}
