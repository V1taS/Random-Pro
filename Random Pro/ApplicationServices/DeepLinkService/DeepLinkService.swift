//
//  DeepLinkService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol DeepLinkService {
  
  /// События Deep links
  ///  - Parameters:
  ///   - scene: Сцена
  ///   - URLContexts: Сыылки url
  ///   - completion: Блок завершения
  func scene(_ scene: UIScene,
             openURLContexts URLContexts: Set<UIOpenURLContext>,
             completion: (DeepLinkType) -> Void)
}

final class DeepLinkServiceImpl: DeepLinkService {
  
  // MARK: - Private property
  
  private lazy var services: ApplicationServices = ApplicationServicesImpl()
  private var coordinator: Coordinator?
  
  // MARK: - Internal func
  
  func scene(_ scene: UIScene,
             openURLContexts URLContexts: Set<UIOpenURLContext>,
             completion: (DeepLinkType) -> Void) {
    guard let firstUrl = URLContexts.first?.url,
          let deepLinkStr = deletingPrefix(fullText: firstUrl.absoluteString, prefix: DeepLinkType.host),
          let deepLinkType = DeepLinkType(rawValue: deepLinkStr) else {
      return
    }
    completion(deepLinkType)
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
