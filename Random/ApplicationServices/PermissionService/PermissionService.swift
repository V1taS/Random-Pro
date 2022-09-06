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
import Photos

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
  
  /// Запрос доступа к Камере
  ///  - Parameter granted: Доступ разрешен
  func requestCamera(_ status: ((_ granted: Bool) -> Void)?)
  
  /// Запрос доступа к Галерее
  ///  - Parameter granted: Доступ разрешен
  func requestPhotos(_ status: ((_ granted: Bool) -> Void)?)
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
  
  func requestCamera(_ status: ((_ granted: Bool) -> Void)?) {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
      DispatchQueue.main.async {
        status?(granted)
      }
    }
  }
  
  func requestPhotos(_ status: ((_ granted: Bool) -> Void)?) {
    if #available(iOS 14, *) {
      PHPhotoLibrary.requestAuthorization(for: .readWrite) { (resultStatus) in
        DispatchQueue.main.async {
          switch resultStatus {
          case .denied, .notDetermined, .restricted:
            status?(false)
          case .authorized, .limited:
            status?(true)
          @unknown default:
            status?(false)
          }
        }
      }
    } else {
      PHPhotoLibrary.requestAuthorization({ resultStatus in
        DispatchQueue.main.async {
          switch resultStatus {
          case .denied, .notDetermined, .restricted:
            status?(false)
          case .authorized, .limited:
            status?(true)
          @unknown default:
            status?(false)
          }
        }
      })
    }
  }
}
