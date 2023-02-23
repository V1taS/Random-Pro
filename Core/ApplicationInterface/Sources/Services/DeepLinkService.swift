//
//  DeepLinkService.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - DeepLinkServiceProtocol

public protocol DeepLinkServiceProtocol {
  
  /// Обработка события
  /// - Parameter urlContexts: Сыылки url
  func eventHandlingWith(urlContexts: Set<UIOpenURLContext>)
  
  /// Запустить глубокую ссылку
  /// - Parameter completion: Возвращает тип ссылки
  func startDeepLink(completion: @escaping (DeepLinkTypeProtocol) -> Void)
}
