//
//  Secrets.swift
//  Random
//
//  Created by Vitalii Sosin on 16.04.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

struct SecretsAPI {
  static var apiKeyYandexMetrica = ""
  static var apiKeyApphud = ""
  static var apiKeyKinopoisk = ""
  static var apiKeyMostPopularMovies = ""
  static var fancyBackend = ""
  
  static var premiumFeatureToggles: [PremiumFeatureToggleModel] = []
  static var advList: [String: String] = [:]
  static var isHiddenToggleForSection: [String: Bool] = [:]
  static var isToggleForFeature: [String: Bool] = [:]
}
