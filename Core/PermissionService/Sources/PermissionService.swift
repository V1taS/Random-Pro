//
//  PermissionService.swift
//  PermissionService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import Contacts
import Photos

public final class PermissionServiceImpl: PermissionServiceProtocol {
  
  public init() {}
  
  public func getNotification(status: @escaping (UNAuthorizationStatus) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.getNotificationSettings { settings in
      DispatchQueue.main.async {
        status(settings.authorizationStatus)
      }
    }
  }
  
  public func requestNotification(_ granted: @escaping (Bool) -> Void) {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { result, _ in
      DispatchQueue.main.async {
        granted(result)
        guard result else { return }
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
  }
  
  @available(iOS 14, *)
  public func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)? = nil) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
  
  public func getIDFA() -> String {
    return ASIdentifierManager.shared().advertisingIdentifier.uuidString
  }
  
  public func requestContactStore(_ status: ((_ granted: Bool, _ error: Error?) -> Void)? = nil) {
    let store = CNContactStore()
    store.requestAccess(for: .contacts) { (granted, error) in
      DispatchQueue.main.async {
        status?(granted, error)
      }
    }
  }
  
  public func requestCamera(_ status: ((_ granted: Bool) -> Void)?) {
    AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
      DispatchQueue.main.async {
        status?(granted)
      }
    }
  }
  
  public func requestPhotos(_ status: ((_ granted: Bool) -> Void)?) {
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

