//
//  FeatureToggleServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

public final class FeatureToggleServicesImpl: FeatureToggleServices {
  public init() {}

  // MARK: - Internal func
  
  public func getPremiumFeatureToggle(models: [PremiumFeatureToggleModel], completion: @escaping (Bool?) -> Void) {
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
    
    for model in models {
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
  
  public func getLabelsFor(section: MainScreenModel.SectionType) -> String {
    SecretsAPI.advList[section.rawValue] ?? ""
  }
  
  public func isHiddenToggleFor(section: MainScreenModel.SectionType) -> Bool {
    SecretsAPI.isHiddenToggleForSection[section.rawValue] ?? false
  }
  
  public func isToggleFor(feature: FeatureToggleType) -> Bool {
    SecretsAPI.isToggleForFeature[feature.rawValue] ?? false
  }
}

// MARK: - Appearance

private extension FeatureToggleServicesImpl {
  struct Appearance {
    let premiumFeatureTogglesKey = "PremiumFeatureToggles"
  }
}
