//
//  FeatureToggleServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

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
}

final class FeatureToggleServicesImpl: FeatureToggleServices {
  
  // MARK: - Internal func
  
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void) {
    let appearance = Appearance()
    
    guard let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString else {
      DispatchQueue.main.async {
        completion(nil)
      }
      return
    }
    
#if DEBUG
    // swiftlint:disable:next no_print
    print("IdentifierForVendor: \(identifierForVendor)")
#endif
    
    for model in SecretsAPI.premiumFeatureToggles {
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
  
  func getLabelsFor(section: MainScreenModel.SectionType) -> String {
    SecretsAPI.advList[section.rawValue] ?? ""
  }
  
  func isHiddenToggleFor(section: MainScreenModel.SectionType) -> Bool {
    SecretsAPI.isHiddenToggleForSection[section.rawValue] ?? true
  }
  
  func isToggleFor(feature: FeatureToggleType) -> Bool {
    SecretsAPI.isToggleForFeature[feature.rawValue] ?? false
  }
}

// MARK: - Appearance

private extension FeatureToggleServicesImpl {
  struct Appearance {
    let premiumFeatureTogglesKey = "PremiumFeatureToggles"
  }
}
