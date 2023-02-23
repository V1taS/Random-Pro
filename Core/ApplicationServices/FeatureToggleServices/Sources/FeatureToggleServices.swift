//
//  FeatureToggleServices.swift
//  FeatureToggleServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import FirebaseFirestore
import UIKit
import ApplicationInterface

public final class FeatureToggleServicesImpl: FeatureToggleServicesProtocol {
  
  // MARK: - Private property
  
  private let cloudDataBase = Firestore.firestore()
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Internal func
  
  public func getUpdateAppFeatureToggle(completion: @escaping (_ isUpdateAvailable: Bool) -> Void) {
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
  
  public func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void) {
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
  
  public func getLabelsFeatureToggle(completion: @escaping (LabelsFeatureToggleModelProtocol?) -> Void) {
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
  
  public func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModelProtocol?) -> Void) {
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

