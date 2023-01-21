//
//  FeatureToggleServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import FirebaseFirestore
import UIKit

protocol FeatureToggleServices {
  
  /// Получить секции, которые надо скрыть из приложения
  func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModel?) -> Void)
  
  /// Получить лайблы для ячеек на главном экране
  func getLabelsFeatureToggle(completion: @escaping (LabelsFeatureToggleModel?) -> Void)
  
  /// Получить премиум
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void)
  
  /// Получить возможность показывать баннер обнови приложение
  func getUpdateAppFeatureToggle(completion: @escaping (_ isUpdateAvailable: Bool) -> Void)
}

final class FeatureToggleServicesImpl: FeatureToggleServices {
  
  // MARK: - Private property
  
  private let cloudDataBase = Firestore.firestore()
  
  // MARK: - Internal func
  
  func getUpdateAppFeatureToggle(completion: @escaping (_ isUpdateAvailable: Bool) -> Void) {
    let appearance = Appearance()
    
    cloudDataBase.collection(appearance.updateAppFeatureToggleKey).getDocuments { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents,
            error == nil else {
        DispatchQueue.main.async {
          completion(false)
        }
        return
      }
      
      for document in documents {
        DispatchQueue.main.async {
          let isUpdateAvailable = UpdateAppFeatureToggleModel(dictionary: document.data()).isUpdateAvailable
          completion(isUpdateAvailable)
        }
      }
    }
  }
  
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
  
  func getLabelsFeatureToggle(completion: @escaping (LabelsFeatureToggleModel?) -> Void) {
    let appearance = Appearance()
    
    cloudDataBase.collection(appearance.labelsFeatureToggleKey).getDocuments { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents, error == nil else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      for document in documents {
        DispatchQueue.main.async {
          completion(LabelsFeatureToggleModel(dictionary: document.data()))
        }
      }
    }
  }
  
  func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModel?) -> Void) {
    let appearance = Appearance()
    
    cloudDataBase.collection(appearance.sectionsIsHiddenFTKey).getDocuments { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents, error == nil else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      for document in documents {
        DispatchQueue.main.async {
          completion(SectionsIsHiddenFTModel(dictionary: document.data()))
        }
      }
    }
  }
}

// MARK: - Appearance

private extension FeatureToggleServicesImpl {
  struct Appearance {
    let sectionsIsHiddenFTKey = "IsHiddenFeatureToggles"
    let labelsFeatureToggleKey = "LabelsFeatureToggle_hit_new_premium_none"
    let premiumFeatureTogglesKey = "PremiumFeatureToggles"
    let updateAppFeatureToggleKey = "UpdateAppFeatureToggle"
  }
}
