//
//  DeepLinkService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FirebaseDynamicLinks

/// Тип данных для динамической ссылки
typealias DynamicLinkUserInfo = (type: DynamicLinkType, userID: String)

protocol DeepLinkService {
  
  /// Обработка события
  /// - Parameter deepLimkURL: Сыылки url
  func eventHandlingWith(deepLimkURL: URL?)
  
  /// Получен определенный тип диплинка
  var deepLinkType: DeepLinkType? { get set }
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
  
  // MARK: - Private property
  
  /// Имя хоста
  private var host: String {
    return "random://"
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
  }
  
  func createDynamicLink(with type: DynamicLinkType) -> String? {
    let appearance = Appearance()
    guard let userID = UIDevice.current.identifierForVendor?.uuidString else {
      return nil
    }
    
    guard let link = URL(string: "\(appearance.scheme)://\(type.rawValue)?userID=\(userID)") else {
      return nil
    }
    
    let components = DynamicLinkComponents(
      link: link,
      domainURIPrefix: appearance.dynamicLinksDomainURIPrefix
    )
    let iOSParams = DynamicLinkIOSParameters(bundleID: appearance.bundleID)
    iOSParams.appStoreID = appearance.appStoreID
    components?.iOSParameters = iOSParams
    return components?.url?.absoluteString
  }
  
  func parseDynamicLink(_ url: URL, completion: ((DynamicLinkUserInfo) -> Void)? ) {
    // Проверяем, что схема URL соответствует вашей схеме
    let appearance = Appearance()
    guard url.scheme == appearance.scheme else {
      return
    }
    
    // Разбор URL на компоненты
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
    
    // Извлекаем тип
    let pathString = components?.path.trimmingCharacters(in: ["/"])
    let type: DynamicLinkType? = pathString.flatMap { DynamicLinkType(rawValue: $0) }
    
    // Извлекаем userID
    let userID = components?.queryItems?.first(where: { $0.name == "userID" })?.value
    
    guard let type, let userID else {
      return
    }
    completion?((type, userID))
  }
}

// MARK: - Appearance

private extension DeepLinkServiceImpl {
  struct Appearance {
    let dynamicLinksDomainURIPrefix = "https://randomsv.page.link"
    let bundleID = "com.sosinvitalii.Random"
    let appStoreID = "1552813956"
    let scheme = "random_pro"
    let dynamicLinkUserInfoKey = "DynamicLinkUserInfoKey"
  }
}
