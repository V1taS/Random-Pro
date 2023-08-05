//
//  FeatureToggleServicesMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class FeatureToggleServicesMock: FeatureToggleServices {
  
  var didReceiveToggle: (() -> Void)?
  
  // Spy variables
  var getSectionsIsHiddenFTCalled = false
  var getLabelsFeatureToggleCalled = false
  var getPremiumFeatureToggleCalled = false
  var getUpdateAppFeatureToggleCalled = false
  
  // Stub variables
  var sectionsIsHiddenFTStub: (() -> Void)?
  var labelsFeatureToggleStub: (() -> Void)?
  var premiumFeatureToggleStub: (() -> Void)?
  var updateAppFeatureToggleStub: (() -> Void)?
  
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void) {
    getPremiumFeatureToggleCalled = true
    premiumFeatureToggleStub?()
    completion(nil)
  }
  
  func getUpdateAppFeatureToggle(completion: @escaping (Bool) -> Void) {
    getUpdateAppFeatureToggleCalled = true
    updateAppFeatureToggleStub?()
    completion(false)
  }
  
  func isToggleFor(feature: Random.FeatureToggleType) -> Bool {
    return false
  }
  
  func isHiddenToggleFor(section: Random.MainScreenModel.SectionType) -> Bool {
    return false
  }
  
  func getLabelsFor(section: Random.MainScreenModel.SectionType) -> String {
    return ""
  }
  
  func fetchRemoteConfig(completion: @escaping (Error?) -> Void) {}
}
