//
//  PremiumFeatureToggleModel.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public struct PremiumFeatureToggleModel: PremiumFeatureToggleModelProtocol {
  
  /// Уникальное ID устройства
  public let id: String?
  
  public let isPremium: Bool?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - dictionary: Словарь с фича тогглами
  public init(dictionary: [String: Any]) {
    id = dictionary["id"] as? String
    isPremium = (dictionary["isPremium"] as? Int ?? .zero).boolValue
  }
}

// MARK: - Private func

private extension Int {
  var boolValue: Bool {
    return (self as NSNumber).boolValue
  }
}
