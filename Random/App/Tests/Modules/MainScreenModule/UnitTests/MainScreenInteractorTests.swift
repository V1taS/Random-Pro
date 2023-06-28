//
//  MainScreenInteractorTests.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import XCTest
@testable import Random

// Unit Test for MainScreenInteractor
final class MainScreenInteractorTests: XCTestCase {
  
  private var interactor: MainScreenInteractor!
  private var outputSpy: MainScreenInteractorOutputSpy!
  private var services: ApplicationServices!
  
  // MARK: - Set up and Tear down
  
  override func setUp() {
    super.setUp()
    outputSpy = MainScreenInteractorOutputSpy()
    let services: ApplicationServices = ApplicationServicesMock()
    self.services = services
    interactor = MainScreenInteractor(services: services)
    interactor.output = outputSpy
  }
  
  override func tearDown() {
    interactor = nil
    outputSpy = nil
    services = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  // Test for updateSectionsWith
  func testUpdateSectionsWith() {
    // Arrange
    let expectation = self.expectation(description: "updateSectionsWith")

    MainScreenFactory.createBaseModel { [unowned self] mainScreenModel in
      // Act
      interactor.updateSectionsWith(model: mainScreenModel)
      
      // Assert
      XCTAssertTrue(outputSpy.didReceiveModelCalled)
      XCTAssertEqual(outputSpy.receivedModel, mainScreenModel)

      expectation.fulfill()
    }

    // Wait for the expectation to fulfill, if timeout happens, test case will fail.
    waitForExpectations(timeout: 5.0, handler: nil)
  }
  
  // Test for getContent
  func testGetContent() {
    // Arrange
    let expectation = self.expectation(description: "getContent")
    
    // Act
    interactor.getContent {
      expectation.fulfill()
    }
    
    // Assert
    waitForExpectations(timeout: 5.0, handler: nil)
    XCTAssertTrue(outputSpy.didReceiveModelCalled)
  }
  
  // Test for returnModel
  func testReturnModel() {
    MainScreenFactory.createBaseModel { [unowned self] mainScreenModel in
      // Arrange
      let model = mainScreenModel
      let expectation = self.expectation(description: "returnModel")

      // Act
      interactor.returnModel { result in
        // Assert
        XCTAssertEqual(result, model)
        expectation.fulfill()
      }

      waitForExpectations(timeout: 5.0, handler: nil)
    }
  }
  
  // Test for saveDarkModeStatus
  func testSaveDarkModeStatus() {
    MainScreenFactory.createBaseModel { [unowned self] mainScreenModel in
      // Arrange
      let darkModeStatus = true
      
      // Act
      interactor.saveDarkModeStatus(darkModeStatus)
      
      // Assert
      if let storageServiceMock = services.storageService as? StorageServiceMock, let model = storageServiceMock.getData(from: MainScreenModel.self) {
        XCTAssertEqual(model.isDarkMode, darkModeStatus)
      } else {
        XCTFail("Failed to cast services.storageService to StorageServiceMock or failed to get data")
      }
    }
  }
  
  // Test for savePremium
  func testSavePremium() {
    // Arrange
    let premiumStatus = true
    
    // Act
    interactor.savePremium(premiumStatus)
    
    // Assert
    let storageServiceMock = services.storageService as? StorageServiceMock
    let model = storageServiceMock?.getData(from: MainScreenModel.self)
    XCTAssertEqual(model?.isPremium, premiumStatus)
    XCTAssertTrue(outputSpy.didReceiveModelCalled)
  }
}
