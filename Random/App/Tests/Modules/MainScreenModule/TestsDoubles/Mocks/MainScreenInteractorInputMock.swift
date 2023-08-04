//
//  MainScreenInteractorInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random

/// Mock Input
final class MainScreenInteractorInputMock: MainScreenInteractorInput {

  // MARK: - Internal properties
  
  weak var output: MainScreenInteractorOutput?
  
  // MARK: - Флаги вызовов функция
  
  var isUpdateSectionsWith: Bool = false
  var isGetContent: Bool = false
  var isReturnModel: Bool = false
  var isSaveDarkModeStatus: Bool = false
  
  // MARK: - MainScreenInteractorInput
  
  func updateSectionsWith(models: [MainScreenModel.Section]) {
    isUpdateSectionsWith = true
    output?.didReceive(model: MainScreenModel(isDarkMode: nil,
                                              isPremium: false,
                                              allSections: models))
  }
  
  func getContent() {
    isGetContent = true
    output?.didReceive(model: MainScreenModel(isDarkMode: nil,
                                              isPremium: false,
                                              allSections: []))
  }
  
  func returnModel() -> MainScreenModel {
    isReturnModel = true
    return MainScreenModel(isDarkMode: nil,
                           isPremium: false,
                           allSections: [])
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    isSaveDarkModeStatus = true
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    // TODO: write tests
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    // TODO: write tests
  }
  
  func updateSectionsWith(model: MainScreenModel) {
    // TODO: -
  }
  
  func getContent(completion: @escaping () -> Void) {
    // TODO: -
  }
  
  func returnModel(completion: @escaping (MainScreenModel) -> Void) {
    // TODO: -
  }
  
  func updatesSectionsIsHiddenFT(completion: @escaping () -> Void) {
    // TODO: -
  }
  
  func updatesLabelsFeatureToggle(completion: @escaping () -> Void) {
    // TODO: -
  }
  
  func validatePurchase(completion: @escaping () -> Void) {
    // TODO: -
  }
  
  func updatesPremiumFeatureToggle(completion: @escaping () -> Void) {
    // TODO: -
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool?) {
    // TODO: -
  }
  
  func savePremium(_ isEnabled: Bool) {
    // TODO: -
  }
  
  func isAutoShowReferalPresentationAgain(completion: @escaping (Bool) -> Void) {
    
  }
}
