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
  
  func getConfigurationValue(forKey key: String) -> String? {
    if let value = cloudKitStorage?[key] {
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
      case .success(let value):
        if let value = value {
          retrievedValue = value
          var cloudKitStorageUpdated = cloudKitStorage ?? [:]
          cloudKitStorageUpdated.updateValue(value, forKey: key)
          self.cloudKitStorage = cloudKitStorageUpdated
        }
      case .failure(let error):
        print("Ошибка получения значения конфигурации: \(error.localizedDescription)")
      }
      
      semaphore.signal()
    }
    
    // Ожидаем завершения асинхронной операции
    semaphore.wait()
    
    return retrievedValue
  }
}

// MARK: - Private

private enum Constants {
  static let apiKeyYandexMetricaKey = "apiKeyYandexMetrica"
  static let apiKeyApphudKey = "apiKeyApphud"
  static let apiKeyKinopoiskKey = "apiKeyKinopoisk"
  static let apiKeyMostPopularMoviesKey = "apiKeyMostPopularMovies"
  static let fancyBackendKey = "fancyBackend"
  
  static let cloudKitServiceKey = "CloudKitServiceKey"
}
