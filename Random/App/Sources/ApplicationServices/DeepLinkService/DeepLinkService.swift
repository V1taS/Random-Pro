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
}

final class DeepLinkServiceImpl: DeepLinkService {
  
  // MARK: - Internal property
  
  var deepLinkType: DeepLinkType? {
    get {
      StorageServiceImpl().deepLinkModel
    } set {
      StorageServiceImpl().deepLinkModel = newValue
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
}

// MARK: - Appearance

private extension DeepLinkServiceImpl {
  struct Appearance {}
}
