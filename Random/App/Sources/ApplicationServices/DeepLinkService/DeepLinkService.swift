//
//  DeepLinkService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol DeepLinkService {
  
  /// Обработка события
  /// - Parameter deepLimkURL: Сыылки url
  func eventHandlingWith(deepLimkURL: URL?)
  
  /// Получен определенный тип диплинка
  var deepLinkType: DeepLinkType? { get set }
  
  /// Динамическая линка
  var dynamicLinkType: DynamicLinkType? { get set }
}

final class DeepLinkServiceImpl: DeepLinkService {
  
  // MARK: - Internal property
  
  var deepLinkType: DeepLinkType? {
    get {
      return StorageServiceImpl().getData(from: DeepLinkType.self)
    } set {
      StorageServiceImpl().saveData(newValue)
    }
  }
  
  var dynamicLinkType: DynamicLinkType? {
    get {
      return StorageServiceImpl().getData(from: DynamicLinkType.self)
    } set {
      StorageServiceImpl().saveData(newValue)
    }
  }
  
  // MARK: - Private property
  
  /// Имя хоста
  private var host: String {
    return "randomPro://"
  }
  
  // MARK: - Internal func
  
  func eventHandlingWith(deepLimkURL: URL?) {
    guard let firstUrl = deepLimkURL?.absoluteString else {
      return
    }
    
    DeepLinkType.allCases.forEach { type in
      if firstUrl.contains(type.deepLinkEndPoint) {
        deepLinkType = type
        return
      }
    }
    
    if deepLinkType == nil {
      parseDynamicLink(deepLimkURL) { [weak self] result in
        self?.dynamicLinkType = result
      }
    }
  }
  
  func parseDynamicLink(_ url: URL?, completion: ((DynamicLinkType) -> Void)?) {
    guard let url = url else {
      return
    }
    
    // Разбор URL на компоненты
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    
    if let linkComponent = components?.queryItems?.first(where: { $0.name == "link" }),
       let linkValue = linkComponent.value,
       let linkURL = URL(string: linkValue) {
      // Обработка динамической ссылки от Firebase
      let innerComponents = URLComponents(url: linkURL, resolvingAgainstBaseURL: true)
      parseComponents(innerComponents, completion: completion)
    } else {
      // Обработка прямой ссылки
      parseComponents(components, completion: completion)
    }
  }
  
  func parseComponents(_ components: URLComponents?, completion: ((DynamicLinkType) -> Void)?) {
    // Извлекаем userID
    let userID = components?.queryItems?.first(where: { $0.name == "userID" })?.value
    
    // Извлекаем тип
    let pathString = components?.path.trimmingCharacters(in: ["/"]) ?? ""
    let path = pathString.isEmpty ? components?.host : pathString
    
    for type in DynamicLinkType.allCases {
      switch type {
      case .invite:
        if let path, path.contains(type.rawValue) {
          if let userID = userID {
            completion?(.invite(userInfo: userID))
            return
          }
        }
      case .freePremium:
        if let path, path.contains(type.rawValue) {
          completion?(.freePremium)
          return
        }
      }
    }
  }
}

// MARK: - Appearance

private extension DeepLinkServiceImpl {
  struct Appearance {
    let dynamicLinksDomainURIPageLinkPrefix = "https://randomsv.page.link"
    let dynamicLinksDomainURIRandomPrefix = "https://random-pro.sosinvitalii.com"
    let bundleID = "com.sosinvitalii.Random"
    let appStoreID = "1552813956"
    let scheme = "randomPro"
    let dynamicLinkUserInfoKey = "DynamicLinkUserInfoKey"
  }
}
