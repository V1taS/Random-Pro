//
//  FeatureToggleServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import FirebaseFirestore
import FirebaseRemoteConfig
import UIKit

protocol FeatureToggleServices {
  
  /// Проверить тоггл для определенного функционала
  func isToggleFor(feature: FeatureToggleType) -> Bool
  
  /// Получить секции, которые надо скрыть из приложения
  func isHiddenToggleFor(section: MainScreenModel.SectionType) -> Bool
  
  /// Получить лайблы для ячеек на главном экране
  func getLabelsFor(section: MainScreenModel.SectionType) -> String
  
  /// Получить премиум
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void)
  
  /// Получить удаленные тогглы
  func fetchRemoteConfig(completion: @escaping (_ error: Error?) -> Void)
}

final class FeatureToggleServicesImpl: FeatureToggleServices {
  
  // MARK: - Private property
  
  private let cloudDataBase = Firestore.firestore()
  private let remoteConfig: RemoteConfig = {
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings
    return remoteConfig
  }()
  
  // MARK: - Internal func
  
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void) {
    let appearance = Appearance()
    
    cloudDataBase.collection(appearance.premiumFeatureTogglesKey).getDocuments { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents,
            let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString,
            error == nil else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
#if DEBUG
      // swiftlint:disable:next no_print
      print("IdentifierForVendor: \(identifierForVendor)")
#endif
      
      for document in documents {
        let model = PremiumFeatureToggleModel(dictionary: document.data())
        guard let id = model.id,
              let isPremium = model.isPremium,
              identifierForVendor == id else {
          continue
        }
        
        DispatchQueue.main.async {
          completion(isPremium)
        }
        return
      }
      DispatchQueue.main.async {
        completion(nil)
      }
      return
    }
  }
  
  func getLabelsFor(section: MainScreenModel.SectionType) -> String {
    remoteConfig.configValue(forKey: "\(section.rawValue)_adv").stringValue ?? ""
  }
  
  func isHiddenToggleFor(section: MainScreenModel.SectionType) -> Bool {
    remoteConfig.configValue(forKey: section.rawValue).boolValue
  }
  
  func isToggleFor(feature: FeatureToggleType) -> Bool {
    remoteConfig.configValue(forKey: feature.rawValue).boolValue
  }
  
  func fetchRemoteConfig(completion: @escaping (_ error: Error?) -> Void) {
    remoteConfig.fetch { [weak self] (status, error) in
      if status == .success {
        self?.remoteConfig.activate { _, error in
          if let error = error {
            completion(error)
          } else {
            completion(nil)
          }
        }
      } else {
        completion(error)
      }
    }
  }
}

// MARK: - Appearance

private extension FeatureToggleServicesImpl {
  struct Appearance {
    let premiumFeatureTogglesKey = "PremiumFeatureToggles"
  }
}
