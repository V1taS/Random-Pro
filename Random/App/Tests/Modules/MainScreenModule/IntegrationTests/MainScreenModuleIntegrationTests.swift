//
//  MainScreenModuleIntegrationTests.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class MainScreenModuleIntegrationTests: XCTestCase {
  
  // MARK: - Private property
  
  // System under test (Тестируемая система)
  private var sut: MainScreenViewController!
  private var localSaveModel: MainScreenModel?
  
  private var interactor: MainScreenInteractorInputMock!
  private var factory: MainScreenFactoryInputMock!
  private var view: MainScreenViewInputMock!
  
  // MARK: - Производим инициализацию объектов для тестирования
  
  override func setUp() {
    super.setUp()
    
    interactor = MainScreenInteractorInputMock()
    factory = MainScreenFactoryInputMock()
    view = MainScreenViewInputMock()
    
    sut = MainScreenViewController(moduleView: view,
                                   interactor: interactor,
                                   factory: factory)
    interactor.output = sut
    factory.output = sut
    view.output = sut
  }
  
  // MARK: - Освождаем ресурсы
  
  override func tearDown() {
    sut = nil
    interactor = nil
    factory = nil
    view = nil
    localSaveModel = nil
    super.tearDown()
  }
  
  // MARK: - Тестируем
  
  func testSaveDarkModeStatus() {
    // Arrange
    let isEnabled = true
    
    // Act
    sut.saveDarkModeStatus(isEnabled)
    
    // Assert
    XCTAssertTrue(interactor.isSaveDarkModeStatus)
  }
  
  func testReturnModel() {
    // Act
    sut.viewDidLoad()  // or any action that calls returnModel
    
    // Assert
    XCTAssertTrue(interactor.isReturnModel)
  }
}

// MARK: - Appearance

extension MainScreenModuleIntegrationTests {
  struct Appearance {
    let keyUserDefaults = "main_screen_user_defaults_key"
  }
}
