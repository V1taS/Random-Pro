//
//  ConfigurationValueConfigurator.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import ApphudSDK

final class ConfigurationValueConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  private lazy var cloudKitService: ICloudKitService = services.cloudKitService
  
  // MARK: - Init
  
  init(services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    let isReachable = NetworkReachabilityService()?.isReachable ?? false
    guard isReachable else { return }
    
    Task {
      await getApphud()
      await getKinopoisk()
      await getMostPopularMovies()
      await getPremiumFeatureToggles()
      await getADVList()
      await getIsHiddenToggleForSection()
      await getIsToggleForFeature()
      await getSupportMail()
      DispatchQueue.main.async {
        NotificationCenter.default.post(
          name: Notification.Name(SecretsAPI.notificationPremiumFeatureToggles),
          object: nil,
          userInfo: [:]
        )
      }
    }
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func getApphud() async {
    if let value = await getConfigurationValue(forKey: Constants.apiKeyApphudKey) {
      DispatchQueue.main.async {
        Apphud.start(apiKey: value)
      }
    }
  }
  
  func getKinopoisk() async {
    if let value = await getConfigurationValue(forKey: Constants.apiKeyKinopoiskKey) {
      SecretsAPI.apiKeyKinopoisk = value
    }
  }
  
  func getMostPopularMovies() async {
    if let value = await getConfigurationValue(forKey: Constants.apiKeyMostPopularMoviesKey) {
      SecretsAPI.apiKeyMostPopularMovies = value
    }
  }
  
  func getSupportMail() async {
    if let value = await getConfigurationValue(forKey: Constants.supportMailKey) {
      SecretsAPI.supportMail = value
    }
  }
  
  func getPremiumFeatureToggles() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.premiumFeatureTogglesKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([PremiumFeatureToggleModel].self, from: jsonData) {
      SecretsAPI.premiumFeatureToggles = models
    }
  }
  
  func getADVList() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.advListKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: String].self, from: jsonData) {
      SecretsAPI.advList = models
    }
  }
  
  func getIsHiddenToggleForSection() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.isHiddenToggleForSectionKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: Bool].self, from: jsonData) {
      SecretsAPI.isHiddenToggleForSection = models
    }
  }
  
  func getIsToggleForFeature() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.isToggleForFeatureKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: Bool].self, from: jsonData) {
      SecretsAPI.isToggleForFeature = models
    }
  }
  
  func getConfigurationValue(forKey key: String) async -> String? {
    await withCheckedContinuation { continuation in
      cloudKitService.getConfigurationValue(
        from: key,
        recordTypes: .config
      ) { (result: Result<String?, Error>) in
        switch result {
        case let .success(value):
          continuation.resume(returning: value)
        case .failure:
          continuation.resume(returning: nil)
        }
      }
    }
  }
}

// MARK: - Private

private enum Constants {
  static let apiKeyApphudKey = "apiKeyApphud"
  static let apiKeyKinopoiskKey = "apiKeyKinopoisk"
  static let apiKeyMostPopularMoviesKey = "apiKeyMostPopularMovies"
  static let supportMailKey = "supportMail"
  
  static let premiumFeatureTogglesKey = "premiumFeatureToggles"
  static let advListKey = "advList"
  static let isHiddenToggleForSectionKey = "isHiddenToggleForSection"
  static let isToggleForFeatureKey = "isToggleForFeature"
  
  static let cloudKitServiceKey = "CloudKitServiceKey"
}
