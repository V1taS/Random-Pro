//
//  SecretsAPI.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public struct SecretsAPI {
  public static var amplitude = ""
  public static var apiKeyKinopoisk = ""
  public static var apiKeyMostPopularMovies = ""
  public static var supportMail = ""
  public static let notificationPremiumFeatureToggles = "notificationPremiumFeatureToggles"

  public static var advList: [String: String] = [:]
  public static var isHiddenToggleForSection: [String: Bool] = [:]
  public static var isToggleForFeature: [String: Bool] = [:]
  public static var premiumFeatureToggleModel: [PremiumFeatureToggleModel] = []
  public static let advFeatureToggleModelsKey = "ADVFeatureToggleModelKey"
  public static let userPremiumKey = "userPremiumKey"
  public static var isPremium: Bool {
    UserDefaults.standard.bool(forKey: userPremiumKey)
  }
}
