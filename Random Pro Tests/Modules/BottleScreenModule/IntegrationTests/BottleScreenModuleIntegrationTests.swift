//
//  BottleScreenModuleIntegrationTests.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 09.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import XCTest
@testable import Random_Pro

final class BottleScreenModuleIntegrationTests: XCTestCase {
 
  // MARK: - Private property
  
  // System under test (Тестируемая система)
  private var sut: BottleScreenViewController!
  
  private var interactor: BottleScreenInteractorInputMock!
  private var factory: BottleScreenFactoryInputMock!
  private var view: BottleScreenViewInputMock!
  
  // MARK: - Производим инициализацию объектов для тестирования
  
  override func setUp() {
    super.setUp()
    
    view = BottleScreenViewInputMock()
    interactor = BottleScreenInteractorInputMock()
    factory = BottleScreenFactoryInputMock()
    sut = BottleScreenViewController(moduleView: view,
                                     interactor: interactor,
                                     factory: factory)
  }
  
  // MARK: - Освождаем ресурсы
  
  override func tearDown() {
    sut = nil
    interactor = nil
    factory = nil
    view = nil
    super.tearDown()
  }
  
  // MARK: - Тестируем
  
  func testGeneratesBottleRotationTimeAction() {
    // Act
    sut.bottleRotationButtonAction()

    // Assert
    XCTAssertTrue(interactor.isGeneratesBottleRotationTimeAction)
  }

  func testStopBottleRotation() {
    // Act
    sut.stopBottleRotation()
    
    // Assert
    XCTAssertTrue(view.isStopBottleRotation)
  }
  
  func testTactileFeedbackBottleRotates() {
    // Act
    sut.tactileFeedbackBottleRotates()
    
    // Assert
    XCTAssertTrue(view.isTactileFeedbackBottleRotates)
  }
  
  func testResetPositionBottleAction() {
    // Act
    view.resetPositionBottle()
    
    // Assert
    XCTAssertTrue(view.isResetPositionBottle)
  }
}
