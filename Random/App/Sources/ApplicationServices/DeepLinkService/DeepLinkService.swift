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
    return "random_pro://"
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
  
  func parseDynamicLink(_ url: URL?, completion: ((DynamicLinkType) -> Void)? ) {
    // Проверяем, что схема URL соответствует вашей схеме
    let appearance = Appearance()
    guard let url,
          url.scheme == appearance.scheme else {
      return
    }
    
    // Разбор URL на компоненты
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    
    // Извлекаем userID
    let userID = components?.queryItems?.first(where: { $0.name == "userID" })?.value
    
    guard let userID else {
      return
    }
    
    // Извлекаем тип
    let pathString = components?.path.trimmingCharacters(in: ["/"])
    var dynamicLinkType: DynamicLinkType?
    DynamicLinkType.allCases.forEach { type in
      if let pathString, pathString.contains(type.rawValue) {
        switch type {
        case .invite:
          dynamicLinkType = .invite(userInfo: userID)
        case .freePremium:
          dynamicLinkType = .freePremium
        }
        return
      }
    }
    guard let dynamicLinkType else {
      return
    }
    completion?(dynamicLinkType)
  }
}

// MARK: - Appearance

private extension DeepLinkServiceImpl {
  struct Appearance {
    let dynamicLinksDomainURIPageLinkPrefix = "https://randomsv.page.link"
    let dynamicLinksDomainURIRandomPrefix = "https://random-pro.sosinvitalii.com"
    let bundleID = "com.sosinvitalii.Random"
    let appStoreID = "1552813956"
    let scheme = "random_pro"
    let dynamicLinkUserInfoKey = "DynamicLinkUserInfoKey"
  }
}
