//
//  MainScreenViewInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random

/// Mock Input
final class MainScreenViewInputMock: MainScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenViewOutput?
  
  // MARK: - Флаги вызовов функция
  
  var isConfigureCellsWith: Bool = false
  
  // MARK: - MainScreenViewInput
  
  func configureCellsWith(models: [MainScreenModel.Section]) {
    isConfigureCellsWith = true
  }
  
  func configureCellsWith(model: MainScreenModel) {
    // TODO: -
  }
}
