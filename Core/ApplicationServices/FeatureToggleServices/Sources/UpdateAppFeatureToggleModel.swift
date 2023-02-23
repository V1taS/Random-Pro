//
//  UpdateAppFeatureToggleModel.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

public struct UpdateAppFeatureToggleModel: UpdateAppFeatureToggleModelProtocol {
  
  /// Доступность баннера обновить приложение
  public let isUpdateAvailable: Bool
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  public init(dictionary: [String: Any]) {
    isUpdateAvailable = (dictionary["isUpdateAvailable"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}
