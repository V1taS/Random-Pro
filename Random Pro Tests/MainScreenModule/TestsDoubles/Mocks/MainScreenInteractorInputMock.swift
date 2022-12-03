//
//  MainScreenInteractorInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random_Pro

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
                                              allSections: models))
  }
  
  func getContent() {
    isGetContent = true
    output?.didReceive(model: MainScreenModel(isDarkMode: nil,
                                              allSections: []))
  }
  
  func returnModel() -> MainScreenModel {
    isReturnModel = true
    return MainScreenModel(isDarkMode: nil,
                           allSections: [])
  }
  
  func saveDarkModeStatus(_ isEnabled: Bool) {
    isSaveDarkModeStatus = true
  }
}
