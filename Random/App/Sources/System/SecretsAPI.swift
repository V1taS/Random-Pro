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
  static var premiumFeatureToggleModel: [PremiumFeatureToggleModel] = []
  
  static var advFeatureToggleModels: [ADVFeatureToggleModel] {
    get {
      @ObjectCustomUserDefaultsWrapper(key: SecretsAPI.advFeatureToggleModelsKey)
      var dataUserDefaults: [ADVFeatureToggleModel]?
      return dataUserDefaults ?? []
    } set {
      @ObjectCustomUserDefaultsWrapper(key: SecretsAPI.advFeatureToggleModelsKey)
      var dataUserDefaults: [ADVFeatureToggleModel]?
      dataUserDefaults = newValue
    }
  }
  static var advFeatureCategoriesIsShow: (adv1: Bool, adv2: Bool, adv3: Bool, adv4: Bool) {
    let models = SecretsAPI.advFeatureToggleModels
    let adv1 = models.contains(where: { $0.category == "1" })
    let adv2 = models.contains(where: { $0.category == "2" })
    let adv3 = models.contains(where: { $0.category == "3" })
    let adv4 = models.contains(where: { $0.category == "4" })
    return (adv1: adv1, adv2: adv2, adv3: adv3, adv4: adv4)
  }
  private static let advFeatureToggleModelsKey = "ADVFeatureToggleModelKey"
  
  static let userPremiumKey = "userPremiumKey"
  static var isPremium: Bool {
    UserDefaults.standard.bool(forKey: userPremiumKey)
  }
}
