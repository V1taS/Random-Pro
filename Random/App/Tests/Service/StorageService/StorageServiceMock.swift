//
//  StorageServiceMock.swift
//  Random
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class StorageServiceMock: StorageService {
  
  // Spy variables
  var isPremiumGetCalled = false
  var saveDataCalled = false
  var getDataCalled = false
  
  // Stub variables
  var isPremiumStub: Bool = false
  var saveDataStub: Any?
  var getDataStub: Any?
  
  var isPremium: Bool {
    isPremiumGetCalled = true
    return isPremiumStub
  }
  
  func saveData<T: UserDefaultsCodable>(_ data: T?) {
    saveDataCalled = true
    saveDataStub = data
  }
  
  func getData<T: UserDefaultsCodable>(from: T.Type) -> T? {
    getDataCalled = true
    return getDataStub as? T
  }
}
