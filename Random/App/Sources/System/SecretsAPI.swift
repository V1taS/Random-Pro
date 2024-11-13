//
//  Secrets.swift
//  Random
//
//  Created by Vitalii Sosin on 16.04.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SecretsAPI {
  static var apiKeyYandexMetrica = "b4921e71-faf2-4bd3-8bea-e033a76457ae"
  static var apiKeyKinopoisk = ""
  static var apiKeyMostPopularMovies = ""
  static var supportMail = ""
  static let notificationPremiumFeatureToggles = "notificationPremiumFeatureToggles"
  
  static var advList: [String: String] = [:]
  static var isHiddenToggleForSection: [String: Bool] = [:]
  static var isToggleForFeature: [String: Bool] = [:]
  static var advFeatureToggleModels: [ADVFeatureToggleModel] = []
  static var premiumFeatureToggleModel: [PremiumFeatureToggleModel] = []
  
  static let userPremiumKey = "userPremiumKey"
  static var isPremium: Bool {
    UserDefaults.standard.bool(forKey: userPremiumKey)
  }
}
