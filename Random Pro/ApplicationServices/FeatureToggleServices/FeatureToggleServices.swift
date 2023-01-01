//
//  FeatureToggleServices.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol FeatureToggleServices {
  
  /// Получить секции, которые надо скрыть из приложения
  func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModel?) -> Void)
}

final class FeatureToggleServicesImpl: FeatureToggleServices {
  
  // MARK: - Private property
  
  private let cloudDataBase = Firestore.firestore()
  
  // MARK: - Internal func
  
  func getSectionsIsHiddenFT(completion: @escaping (SectionsIsHiddenFTModel?) -> Void) {
    let appearance = Appearance()
    cloudDataBase.collection(appearance.nameCloudDataBase).getDocuments { (querySnapshot, error) in
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
    let nameCloudDataBase = "IsHiddenFeatureToggles"
  }
}
