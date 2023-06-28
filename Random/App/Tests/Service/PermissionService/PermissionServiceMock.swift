//
//  PermissionServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import Contacts
import Photos
import XCTest
@testable import Random

final class PermissionServiceMock: PermissionService {
  
  // Stub variables
  private var _requestIDFAStatus: Int = .zero
  @available(iOS 14, *)
  var requestIDFAStatus: ATTrackingManager.AuthorizationStatus {
    get {
      return ATTrackingManager.AuthorizationStatus(rawValue: UInt(_requestIDFAStatus)) ?? .notDetermined
    }
    set {
      _requestIDFAStatus = Int(newValue.rawValue)
    }
  }
  
  var idfaString: String = ""
  var contactStoreStatus: (Bool, Error?) = (false, nil)
  var cameraAccess: Bool = false
  var photosAccess: Bool = false
  var notificationAccess: Bool = false
  var notificationStatus: UNAuthorizationStatus = .notDetermined
  
  // Spy variables
  var requestIDFACalled: Bool = false
  var getIDFACalled: Bool = false
  var requestContactStoreCalled: Bool = false
  var requestCameraCalled: Bool = false
  var requestPhotosCalled: Bool = false
  var requestNotificationCalled: Bool = false
  var getNotificationCalled: Bool = false
  
  @available(iOS 14, *)
  func requestIDFA(_ status: ((ATTrackingManager.AuthorizationStatus) -> Void)?) {
    requestIDFACalled = true
    status?(requestIDFAStatus)
  }
  
  func getIDFA() -> String {
    getIDFACalled = true
    return idfaString
  }
  
  func requestContactStore(_ status: ((Bool, Error?) -> Void)?) {
    requestContactStoreCalled = true
    status?(contactStoreStatus.0, contactStoreStatus.1)
  }
  
  func requestCamera(_ status: ((Bool) -> Void)?) {
    requestCameraCalled = true
    status?(cameraAccess)
  }
  
  func requestPhotos(_ status: ((Bool) -> Void)?) {
    requestPhotosCalled = true
    status?(photosAccess)
  }
  
  func requestNotification(_ granted: @escaping (Bool) -> Void) {
    requestNotificationCalled = true
    granted(notificationAccess)
  }
  
  func getNotification(status: @escaping (UNAuthorizationStatus) -> Void) {
    getNotificationCalled = true
    status(notificationStatus)
  }
}
