//
//  PermissionService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 26.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import Contacts

protocol PermissionService {
  
  /// Запрос на отслеживание. Доступно с IOS 14
  ///  - Parameter status: Статус ответа пользователя
  @available(iOS 14, *)
  func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)?)
  
  /// Запрос доступа к контактам
  ///  - Parameters:
  ///   - granted: Доступ разрешен
  ///   - error: Ошибка
  func requestContactStore(_ status: ((_ granted: Bool, _ error: Error?) -> Void)?)
}

final class PermissionServiceImpl: PermissionService {
  @available(iOS 14, *)
  func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)? = nil) {
    DispatchQueue.main.async {
      switch ATTrackingManager.trackingAuthorizationStatus {
      case .notDetermined:
        status?(.notDetermined)
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in })
      case .restricted:
        status?(.restricted)
      case .denied:
        status?(.denied)
      case .authorized:
        status?(.authorized)
      @unknown default: break
      }
    }
  }
  
  func requestContactStore(_ status: ((_ granted: Bool, _ error: Error?) -> Void)? = nil) {
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { (granted, error) in
      DispatchQueue.main.async {
        status?(granted, error)
      }
    }
  }
}
