//
//  PermissionService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation
import AppTrackingTransparency
import UserNotifications

public protocol PermissionService {

  /// Запрос на отслеживание. Доступно с IOS 14
  ///  - Parameter status: Статус ответа пользователя
  @available(iOS 14, *)
  func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)?)

  /// Получить рекламный ID
  func getIDFA() -> String

  /// Запрос доступа к контактам
  ///  - Parameters:
  ///   - granted: Доступ разрешен
  ///   - error: Ошибка
  func requestContactStore(_ status: ((_ granted: Bool, _ error: Error?) -> Void)?)

  /// Запрос доступа к Камере
  ///  - Parameter granted: Доступ разрешен
  func requestCamera(_ status: ((_ granted: Bool) -> Void)?)

  /// Запрос доступа к Галерее
  ///  - Parameter granted: Доступ разрешен
  func requestPhotos(_ status: ((_ granted: Bool) -> Void)?)

  /// Запрос доступа к Уведомлениям
  ///  - Parameter granted: Доступ разрешен
  func requestNotification(_ granted: @escaping (Bool) -> Void)

  /// Получить статус уведомлений
  ///  - Parameter granted: Доступ разрешен
  func getNotification(status: @escaping (UNAuthorizationStatus) -> Void)
}
