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
  
  // MARK: - Spy variables to check if the methods were called
  
  var isConfigureCellsWithModel = false
  
  // MARK: - Stub variables to mimic the returned values
  
  // MARK: - MainScreenViewInput
  
  func configureCellsWith(model: MainScreenModel) {
    isConfigureCellsWithModel = true
  }
}
