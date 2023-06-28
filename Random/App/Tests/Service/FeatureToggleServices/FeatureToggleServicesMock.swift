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
  var sectionsIsHiddenFT: Random.SectionsIsHiddenFTModel?
  var labelsFeatureToggle: Random.LabelsFeatureToggleModel?
  var premiumFeatureToggle: Bool?
  var updateAppFeatureToggle: Bool?
  
  func getSectionsIsHiddenFT(completion: @escaping (Random.SectionsIsHiddenFTModel?) -> Void) {
    getSectionsIsHiddenFTCalled = true
    completion(sectionsIsHiddenFT)
  }
  
  func getLabelsFeatureToggle(completion: @escaping (Random.LabelsFeatureToggleModel?) -> Void) {
    getLabelsFeatureToggleCalled = true
    completion(labelsFeatureToggle)
  }
  
  func getPremiumFeatureToggle(completion: @escaping (Bool?) -> Void) {
    getPremiumFeatureToggleCalled = true
    completion(premiumFeatureToggle)
  }
  
  func getUpdateAppFeatureToggle(completion: @escaping (Bool) -> Void) {
    getUpdateAppFeatureToggleCalled = true
    completion(updateAppFeatureToggle ?? false)
  }
}
