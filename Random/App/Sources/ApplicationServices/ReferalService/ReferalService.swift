//
//  ReferalService.swift
//  Random
//
//  Created by Vitalii Sosin on 01.08.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import FirebaseFirestore
import FirebaseDynamicLinks
import UIKit

protocol ReferalService {
  
  /// Молучить информацию о себе
  func getSelfInfo(completion: @escaping (ReferalModel?) -> Void)
  
  /// Сохранить информацию, когда сработада динамическая линка
  func saveInfo(friendID: String?, completion: ((Result<Void, ReferalError>) -> Void)?)
  
  /// Бесплатный премиум подключен
  func freePremium(completion: ((Result<Void, ReferalError>) -> Void)?)
  
  /// Создать динамическую ссылку
  func createDynamicLink() -> String?
}

final class ReferalServiceImpl: ReferalService {
  
  // MARK: - Private property
  
  private let cloudDataBase = Firestore.firestore()
  
  // MARK: - Func
  
  func freePremium(completion: ((Result<Void, ReferalError>) -> Void)?) {
    guard let selfID = UIDevice.current.identifierForVendor?.uuidString else {
      completion?(.failure(.failedToGetIdentifier))
      return
    }
    
    let appearance = Appearance()
    let premiumCollection = cloudDataBase.collection(appearance.premiumFeatureTogglesKey)
    
    let premiumData: [String: Any] = [
      appearance.id: selfID,
      appearance.isPremium: true,
      "state": "freePremium"
    ]
    
    premiumCollection.document(selfID).setData(premiumData) { error in
      if let error = error {
        DispatchQueue.main.async {
          completion?(.failure(.failedCreatingNewDocument(error.localizedDescription)))
        }
      } else {
        DispatchQueue.main.async {
          completion?(.success(()))
        }
      }
    }
  }
  
  func saveInfo(friendID: String?, completion: ((Result<Void, ReferalError>) -> Void)?) {
    guard let selfID = UIDevice.current.identifierForVendor?.uuidString,
          let friendID = friendID,
          selfID != friendID else {
      completion?(.failure(.failedToGetIdentifier))
      return
    }
    
    let appearance = Appearance()
    let referralCollection = cloudDataBase.collection(appearance.referralProgram)
    
    referralCollection.document(friendID).getDocument { (document, error) in
      if let error = error {
        DispatchQueue.main.async {
          completion?(.failure(.failedGettingDocument(error.localizedDescription)))
        }
        return
      }
      
      // Ситуация, когда такой документ существует
      if let document = document, document.exists {
        if var data = document.data(), var referals = data[appearance.referals] as? [String] {
          
          // Проверяем, содержится ли selfID уже в массиве referals
          if !referals.contains(selfID) {
            referals.append(selfID)
            data[appearance.referals] = referals
            referralCollection.document(friendID).setData(data) { error in
              if let error = error {
                DispatchQueue.main.async {
                  completion?(.failure(.failedUpdatingDocument(error.localizedDescription)))
                }
              } else {
                DispatchQueue.main.async {
                  // Успех при обновлении документа
                  completion?(.success(()))
                }
              }
            }
          } else {
            // Если selfID уже присутствует, просто возвращаем успех, поскольку нам не нужно повторно добавлять идентификатор.
            DispatchQueue.main.async {
              // Успех, так как selfID уже существует в referals и не требует дополнительных изменений
              completion?(.failure(.failedAlreadyExists))
            }
          }
          
        } else {
          DispatchQueue.main.async {
            completion?(.failure(.failedToUpdateReferals))
          }
        }
      } else { // Ситуация, когда такого документа не существует
        let newReferal: [String: Any] = [
          appearance.id: friendID,
          appearance.referals: [selfID]
        ]
        referralCollection.document(friendID).setData(newReferal) { error in
          if let error = error {
            DispatchQueue.main.async {
              completion?(.failure(.failedCreatingNewDocument(error.localizedDescription)))
            }
            
          } else {
            DispatchQueue.main.async {
              // Успех при создании нового документа
              completion?(.success(()))
            }
          }
        }
      }
    }
  }
  
  func getSelfInfo(completion: @escaping (ReferalModel?) -> Void) {
    cloudDataBase.collection(Appearance().referralProgram).getDocuments { (querySnapshot, error) in
      guard let documents = querySnapshot?.documents,
            let identifierForVendor = UIDevice.current.identifierForVendor?.uuidString,
            error == nil else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      for document in documents {
        let model = ReferalModel(dictionary: document.data())
        guard let id = model.id,
              identifierForVendor == id else {
          continue
        }
        
        DispatchQueue.main.async {
          completion(model)
        }
        return
      }
      DispatchQueue.main.async {
        completion(nil)
      }
      return
    }
  }
  
  func createDynamicLink() -> String? {
    let appearance = Appearance()
    guard let userID = UIDevice.current.identifierForVendor?.uuidString else {
      return nil
    }
    
    guard let link = URL(string: "\(appearance.scheme)://\(DynamicLinkType.invite(userInfo: "").rawValue)?userID=\(userID)") else {
      return nil
    }
    
    let components = DynamicLinkComponents(
      link: link,
      domainURIPrefix: appearance.dynamicLinksDomainURIRandomPrefix
    )
    
    let iOSParams = DynamicLinkIOSParameters(bundleID: appearance.bundleID)
    iOSParams.appStoreID = appearance.appStoreID
    components?.iOSParameters = iOSParams
    
    // Add the efr parameter
    let options = DynamicLinkComponentsOptions()
    options.pathLength = .short
    components?.options = options
    
    return components?.url?.absoluteString
  }
}

// MARK: - Appearance

private extension ReferalServiceImpl {
  struct Appearance {
    let premiumFeatureTogglesKey = "PremiumFeatureToggles"
    let referralProgram = "ReferralProgram"
    let referals = "referals"
    let id = "id"
    let isPremium = "isPremium"
    
    let dynamicLinksDomainURIRandomPrefix = "https://random-pro.sosinvitalii.com"
    let bundleID = "com.sosinvitalii.Random"
    let appStoreID = "1552813956"
    let scheme = "randomPro"
    let dynamicLinkUserInfoKey = "DynamicLinkUserInfoKey"
  }
}
