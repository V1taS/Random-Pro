//
//  ConfigurationValueConfigurator.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit
import ApphudSDK
import SKAbstractions

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
    guard isReachable else {
      return
    }

    Task {
      await getADVFeatureToggles()
      await getPremiumFeatureToggles()
      await getApphud()
      await getKinopoisk()
      await getMostPopularMovies()
      await getADVList()
      await getIsHiddenToggleForSection()
      await getIsToggleForFeature()
      await getSupportMail()
      await getAmplitude()
      updateMainScreen()
    }

#if DEBUG
    print("Отключена валидация покупок в App Store для DEBUG сборки ❌")
    UserDefaults.standard.set(true, forKey: SecretsAPI.userPremiumKey)
    updateMainScreen()
#else
    getValidatePremium()
#endif
    
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

  func getAmplitude() async {
    if let value = await getConfigurationValue(forKey: Constants.amplitude) {
      SecretsAPI.amplitude = value
    }
  }

  func getADVFeatureToggles() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.advFeatureTogglesKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([ADVFeatureToggleModel].self, from: jsonData) {
      SecretsAPI.advFeatureToggleModels = models
    }
  }

  func getValidatePremium() {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      Task { [weak self] in
        guard let self else { return }
        let isValidate = await services.appPurchasesService.restorePurchase()
        services.featureToggleServices.getPremiumFeatureToggle(
          models: SecretsAPI.premiumFeatureToggleModel
        ) { [weak self] isPremium in
          let isPremium = isValidate || isPremium ?? false
          UserDefaults.standard.set(isPremium, forKey: SecretsAPI.userPremiumKey)
          self?.updateMainScreen()
        }
      }
    }
  }

  func getPremiumFeatureToggles() async {
    let decoder = JSONDecoder()
    if let jsonString = await getConfigurationValue(forKey: Constants.premiumFeatureTogglesKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([PremiumFeatureToggleModel].self, from: jsonData) {
      SecretsAPI.premiumFeatureToggleModel = models

      await withCheckedContinuation { [weak self] continuation in
        guard let self else {
          continuation.resume()
          return
        }
        self.services.featureToggleServices.getPremiumFeatureToggle(models: models) { isPremium in
          if let isPremium, isPremium {
            UserDefaults.standard.set(true, forKey: SecretsAPI.userPremiumKey)
          }
          continuation.resume()
        }
      }
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

  func updateMainScreen() {
    DispatchQueue.main.async {
      NotificationCenter.default.post(
        name: Notification.Name(SecretsAPI.notificationPremiumFeatureToggles),
        object: nil,
        userInfo: [:]
      )
    }
  }
}

// MARK: - Private

private enum Constants {
  static let apiKeyApphudKey = "apiKeyApphud"
  static let apiKeyKinopoiskKey = "apiKeyKinopoisk"
  static let apiKeyMostPopularMoviesKey = "apiKeyMostPopularMovies"
  static let supportMailKey = "supportMail"
  static let amplitude = "amplitude"

  static let premiumFeatureTogglesKey = "premiumFeatureToggles"
  static let advListKey = "advList"
  static let isHiddenToggleForSectionKey = "isHiddenToggleForSection"
  static let isToggleForFeatureKey = "isToggleForFeature"
  static let advFeatureTogglesKey = "advFeatureTogglesKey"

  static let cloudKitServiceKey = "CloudKitServiceKey"
}
