//
//  DeepLinkService.swift
//  DeepLinkService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class DeepLinkServiceImpl {

  // MARK: - Private property
  
  private var deepLinkType: DeepLinkType?
  
  // MARK: - Init
  
  public init(deepLinkType: DeepLinkType? = nil) {
    self.deepLinkType = deepLinkType
  }
  
  // MARK: - Internal func
  
  public func eventHandlingWith(urlContexts: Set<UIOpenURLContext>) {
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
  
  public func startDeepLink(completion: @escaping (DeepLinkType) -> Void) {
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
