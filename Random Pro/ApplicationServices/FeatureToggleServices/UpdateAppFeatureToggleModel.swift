//
//  UpdateAppFeatureToggleModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct UpdateAppFeatureToggleModel {
  
  /// Доступность баннера обновить приложение
  let isUpdateAvailable: Bool
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  init(dictionary: [String: Any]) {
    isUpdateAvailable = (dictionary["isUpdateAvailable"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}
