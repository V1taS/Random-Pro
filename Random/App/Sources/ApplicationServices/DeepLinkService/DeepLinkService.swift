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
  /// - Parameter urlContexts: Сыылки url
  func eventHandlingWith(urlContexts: Set<UIOpenURLContext>)
  
  /// Получен определенный тип диплинка
  var deepLinkType: MainScreenModel.SectionType? { get set }
}

final class DeepLinkServiceImpl: DeepLinkService {
  
  // MARK: - Internal property
  
  var deepLinkType: MainScreenModel.SectionType? {
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
  
  func eventHandlingWith(urlContexts: Set<UIOpenURLContext>) {
    guard let firstUrl = urlContexts.first?.url.absoluteString else {
      return
    }
    
    MainScreenModel.SectionType.allCases.forEach { type in
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
