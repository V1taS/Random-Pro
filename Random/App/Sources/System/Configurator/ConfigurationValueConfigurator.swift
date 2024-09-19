//
//  ConfigurationValueConfigurator.swift
//  Random
//
//  Created by Vitalii Sosin on 19.08.2024.
//  Copyright © 2024 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ConfigurationValueConfigurator: Configurator {
  
  // MARK: - Private properties
  
  private let services: ApplicationServices
  private var cloudKitService: ICloudKitService {
    services.cloudKitService
  }
  
  @ObjectCustomUserDefaultsWrapper(key: Constants.cloudKitServiceKey)
  var cloudKitStorage: [String: String]?
  
  // MARK: - Init
  
  init(services: ApplicationServices) {
    self.services = services
  }
  
  // MARK: - Internal func
  
  func configure() {
    getYandexMetrica()
    getApphud()
    getKinopoisk()
    getMostPopularMovies()
    getFancyBackend()
    getPremiumFeatureToggles()
    getADVList()
    getIsHiddenToggleForSection()
    getIsToggleForFeature()
    getSupportMail()
  }
}

// MARK: - Private

private extension ConfigurationValueConfigurator {
  func getYandexMetrica() {
    if let value = getConfigurationValue(forKey: Constants.apiKeyYandexMetricaKey) {
      SecretsAPI.apiKeyYandexMetrica = value
    }
  }
  
  func getApphud() {
    if let value = getConfigurationValue(forKey: Constants.apiKeyApphudKey) {
      SecretsAPI.apiKeyApphud = value
    }
  }
  
  func getKinopoisk() {
    if let value = getConfigurationValue(forKey: Constants.apiKeyKinopoiskKey) {
      SecretsAPI.apiKeyKinopoisk = value
    }
  }
  
  func getMostPopularMovies() {
    if let value = getConfigurationValue(forKey: Constants.apiKeyMostPopularMoviesKey) {
      SecretsAPI.apiKeyMostPopularMovies = value
    }
  }
  
  func getFancyBackend() {
    if let value = getConfigurationValue(forKey: Constants.fancyBackendKey) {
      SecretsAPI.fancyBackend = value
    }
  }
  
  func getSupportMail() {
    if let value = getConfigurationValue(forKey: Constants.supportMailKey) {
      SecretsAPI.supportMail = value
    }
  }
  
  func getPremiumFeatureToggles() {
    let decoder = JSONDecoder()
    if let jsonString = getConfigurationValue(forKey: Constants.premiumFeatureTogglesKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([PremiumFeatureToggleModel].self, from: jsonData) {
      SecretsAPI.premiumFeatureToggles = models
    }
  }
  
  func getADVList() {
    let decoder = JSONDecoder()
    if let jsonString = getConfigurationValue(forKey: Constants.advListKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: String].self, from: jsonData) {
      SecretsAPI.advList = models
    }
  }
  
  func getIsHiddenToggleForSection() {
    let decoder = JSONDecoder()
    if let jsonString = getConfigurationValue(forKey: Constants.isHiddenToggleForSectionKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: Bool].self, from: jsonData) {
      SecretsAPI.isHiddenToggleForSection = models
    }
  }
  
  func getIsToggleForFeature() {
    let decoder = JSONDecoder()
    if let jsonString = getConfigurationValue(forKey: Constants.isToggleForFeatureKey),
       let jsonData = jsonString.data(using: .utf8),
       let models = try? decoder.decode([String: Bool].self, from: jsonData) {
      SecretsAPI.isToggleForFeature = models
    }
  }
  
  func getConfigurationValue(forKey key: String) -> String? {
    if let value = cloudKitStorage?[key], !isMoreThan15MinutesPassed() {
      return value
    }
    
    let semaphore = DispatchSemaphore(value: 0)
    var retrievedValue: String?
    
    cloudKitService.getConfigurationValue(from: key) { [weak self] (result: Result<String?, Error>) in
      guard let self = self else {
        semaphore.signal()
        return
      }
      
      switch result {
      case let .success(value):
        if let value = value {
          retrievedValue = value
          var cloudKitStorageUpdated = cloudKitStorage ?? [:]
          cloudKitStorageUpdated.updateValue(value, forKey: key)
          self.cloudKitStorage = cloudKitStorageUpdated
        }
      case .failure(let error):
        print("Ошибка получения значения конфигурации: \(error.localizedDescription)")
      }
      
      saveDateToStorage()
      semaphore.signal()
    }
    
    // Устанавливаем таймаут в 5 секунд и продолжаем выполнение независимо от результата
    _ = semaphore.wait(timeout: .now() + 5)
    
    return retrievedValue
  }
  
  // Сохраняет текущую дату в сторадж по ключу
  func saveDateToStorage() {
    let currentDate = Date()
    let dateFormatter = ISO8601DateFormatter()
    let dateString = dateFormatter.string(from: currentDate)
    
    var cloudKitStorageUpdated = cloudKitStorage ?? [:]
    cloudKitStorageUpdated[Constants.oneDayPassKey] = dateString
    cloudKitStorage = cloudKitStorageUpdated
  }
  
  // Получает дату из стораджа по ключу
  func getDateFromStorage() -> Date? {
    guard let dateString = cloudKitStorage?[Constants.oneDayPassKey] else { return nil }
    let dateFormatter = ISO8601DateFormatter()
    return dateFormatter.date(from: dateString)
  }
  
  // Проверяет, что прошло больше 15 минут с сохраненной даты
  func isMoreThan15MinutesPassed() -> Bool {
      guard let storedDate = getDateFromStorage() else { return true }
      let timeInterval = Date().timeIntervalSince(storedDate)
      return timeInterval > 15 * 60
  }
}

// MARK: - Private

private enum Constants {
  static let apiKeyYandexMetricaKey = "apiKeyYandexMetrica"
  static let apiKeyApphudKey = "apiKeyApphud"
  static let apiKeyKinopoiskKey = "apiKeyKinopoisk"
  static let apiKeyMostPopularMoviesKey = "apiKeyMostPopularMovies"
  static let fancyBackendKey = "fancyBackend"
  static let supportMailKey = "supportMail"
  
  static let premiumFeatureTogglesKey = "premiumFeatureToggles"
  static let advListKey = "advList"
  static let isHiddenToggleForSectionKey = "isHiddenToggleForSection"
  static let isToggleForFeatureKey = "isToggleForFeature"
  
  static let cloudKitServiceKey = "CloudKitServiceKey"
  static let oneDayPassKey = "OneDayPassKey"
}
