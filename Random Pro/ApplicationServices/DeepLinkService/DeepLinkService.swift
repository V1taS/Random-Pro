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
  
  /// Запустить глубокую ссылку
  /// - Parameter completion: Возвращает тип ссылки
  func startDeepLink(completion: @escaping (DeepLinkType) -> Void)
}

final class DeepLinkServiceImpl: DeepLinkService {
  
  // MARK: - Private property
  
  private var deepLinkType: DeepLinkType? {
    get {
      StorageServiceImpl().deepLinkModel
    } set {
      StorageServiceImpl().deepLinkModel = newValue
    }
  }
  
  // MARK: - Internal func
  
  func eventHandlingWith(urlContexts: Set<UIOpenURLContext>) {
    guard let firstUrl = urlContexts.first?.url.absoluteString else {
      return
    }
    
    DeepLinkType.allCases.forEach { type in
      if firstUrl.contains(type.rawValue) {
        deepLinkType = type
        return
      }
    }
  }
  
  func startDeepLink(completion: @escaping (DeepLinkType) -> Void) {
    guard let deepLinkType else {
      return
    }
    DispatchQueue.main.async {
      completion(deepLinkType)
      self.deepLinkType = nil
    }
  }
}

// MARK: - Private

private extension DeepLinkServiceImpl {
  func deletingPrefix(fullText: String, prefix: String) -> String? {
    guard fullText.hasPrefix(prefix) else {
      return nil
    }
    return String(fullText.dropFirst(prefix.count))
  }
}

// MARK: - Appearance

private extension DeepLinkServiceImpl {
  struct Appearance {}
}
