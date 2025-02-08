//
//  DeepLinkService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol DeepLinkService {

  /// Обработка события
  /// - Parameter deepLimkURL: Сыылки url
  func eventHandlingWith(deepLimkURL: URL?)

  /// Получен определенный тип диплинка
  var deepLinkType: DeepLinkType? { get set }

  /// Динамическая линка
  var dynamicLinkType: DynamicLinkType? { get set }
}
