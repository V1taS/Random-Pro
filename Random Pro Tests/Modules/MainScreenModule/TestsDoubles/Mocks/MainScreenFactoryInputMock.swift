//
//  MainScreenFactoryInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random_Pro

/// Mock Input
final class MainScreenFactoryInputMock: MainScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: MainScreenFactoryOutput?
  
  // MARK: - Флаги вызовов функция
  
  var isCreateCellsFrom: Bool = false
  
  // MARK: - MainScreenFactoryInput
  
  func createCellsFrom(model: MainScreenModel) {
    isCreateCellsFrom = true
    output?.didReceiveNew(model: MainScreenModel(isDarkMode: nil,
                                                 isPremium: false,
                                                 allSections: []))
  }
}
