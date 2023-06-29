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
  
  func getSectionsIsHiddenFT(completion: @escaping (Random.SectionsIsHiddenFTModel?) -> Void) {
    getSectionsIsHiddenFTCalled = true
    sectionsIsHiddenFTStub?()
    completion(nil)
  }
  
  func getLabelsFeatureToggle(completion: @escaping (Random.LabelsFeatureToggleModel?) -> Void) {
    getLabelsFeatureToggleCalled = true
    labelsFeatureToggleStub?()
    completion(nil)
  }
  
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
}
