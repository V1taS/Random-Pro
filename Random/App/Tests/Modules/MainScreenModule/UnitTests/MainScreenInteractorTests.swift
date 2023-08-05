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
    services = ApplicationServicesMock()
    interactor = MainScreenInteractor(services: services, factory: MainScreenFactory(services: services))
    interactor.output = outputSpy
  }
  
  override func tearDown() {
    interactor = nil
    outputSpy = nil
    services = nil
    super.tearDown()
  }
  
  // MARK: - Tests
  
  // Test for getContent
  func testGetContent() {
    // Arrange
    let expectation = expectation(description: "getContent")
    
    // Act
    interactor.getContent {
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertTrue(outputSpy.didReceiveModelCalled)
  }
  
  // Test for returnModel
  func testReturnModel() {
    // Arrange
    let mainScreenModel = MainScreenModel(isDarkMode: nil, isPremium: false, allSections: [])
    let storageServiceMock = services.storageService as? StorageServiceMock
    var receivedModel: MainScreenModel?
    let expectation = expectation(description: "returnModel")
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    interactor.returnModel { result in
      receivedModel = result
      expectation.fulfill()
    }
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(mainScreenModel, receivedModel)
  }
  
  // Test for saveDarkModeStatus
  func testSaveDarkModeStatus() {
    // Arrange
    let mainScreenModel = MainScreenModel(isDarkMode: nil, isPremium: false, allSections: [])
    let storageServiceMock = services.storageService as? StorageServiceMock
    var receivedModel: MainScreenModel?
    let expectation = expectation(description: "storage save data")
    let darkModeStatus = true
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    storageServiceMock?.saveDataStub = { result in
      receivedModel = result as? MainScreenModel
      expectation.fulfill()
    }
    interactor.saveDarkModeStatus(darkModeStatus)
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(receivedModel?.isDarkMode, darkModeStatus)
  }
  
  // Test for savePremium
  func testSavePremium() {
    // Arrange
    let mainScreenModel = MainScreenModel(isDarkMode: nil, isPremium: false, allSections: [])
    let storageServiceMock = services.storageService as? StorageServiceMock
    var receivedStorageModel: MainScreenModel?
    var receivedOutputModel: MainScreenModel?
    let storageExpectation = expectation(description: "storage save data")
    let ouputExpectation = expectation(description: "didReceiveModel output")
    let isPremium = true
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    storageServiceMock?.saveDataStub = { result in
      receivedStorageModel = result as? MainScreenModel
      storageExpectation.fulfill()
    }
    outputSpy.didReceiveModelCompletion = { result in
      receivedOutputModel = result
      ouputExpectation.fulfill()
    }
    interactor.savePremium(isPremium)
    wait(for: [storageExpectation, ouputExpectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(receivedStorageModel?.isPremium, isPremium)
    XCTAssertEqual(receivedStorageModel, receivedOutputModel)
  }
  
  // Test for removeLabelFromSection
  func testRemoveLabelFromSection() {
    // Arrange
    let sectionType: MainScreenModel.SectionType = .coin
    let mainScreenModel = MainScreenModel(
      isDarkMode: nil,
      isPremium: false,
      allSections: [
        .init(type: sectionType, isEnabled: true, isHidden: false, isPremium: false, advLabel: .new),
        .init(type: .bottle, isEnabled: true, isHidden: false, isPremium: false, advLabel: .none)
      ]
    )
    var receivedStorageModel: MainScreenModel?
    let storageServiceMock = services.storageService as? StorageServiceMock
    let expectation = expectation(description: "storage save data")
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    storageServiceMock?.saveDataStub = { result in
      receivedStorageModel = result as? MainScreenModel
      expectation.fulfill()
    }
    interactor.removeLabelFromSection(type: sectionType)
    wait(for: [expectation], timeout: 1)
    
    // Assert
    let section = receivedStorageModel?.allSections.filter({ $0.type == sectionType }).first
    XCTAssertTrue(section?.advLabel != .new)
  }
  
  // Test for updatesPremiumFeatureToggle
  func testUpdatesPremiumFeatureToggle() {
    // Arrange
    let mainScreenModel = MainScreenModel(isDarkMode: nil, isPremium: false, allSections: [])
    let expectation = expectation(description: "updates premium FT called")
    let storageServiceMock = services.storageService as? StorageServiceMock
    let featureToggleServicesMock = services.featureToggleServices as? FeatureToggleServicesMock
    var isPremiumFeatureToggleCalled = false
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    featureToggleServicesMock?.premiumFeatureToggleStub = {
      isPremiumFeatureToggleCalled = true
      expectation.fulfill()
    }
    interactor.updatesPremiumFeatureToggle {}
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertTrue(isPremiumFeatureToggleCalled)
  }
  
  // Test for validatePurchase
  func testValidatePurchase() {
    // Arrange
    let mainScreenModel = MainScreenModel(isDarkMode: nil, isPremium: false, allSections: [])
    let expectation = expectation(description: "validate purchase called")
    let storageServiceMock = services.storageService as? StorageServiceMock
    let appPurchasesService = services.appPurchasesService as? AppPurchasesServiceMock
    var isValidatePurchaseCalled = false
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    appPurchasesService?.isValidatePurchaseStub = {
      isValidatePurchaseCalled = true
      expectation.fulfill()
    }
    interactor.validatePurchase {}
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertTrue(isValidatePurchaseCalled)
  }
  
  // Test for addLabel
  func testAddLabel() {
    // Arrange
    var receivedStorageModel: MainScreenModel?
    let advLabel: MainScreenModel.ADVLabel = .hit
    let sectionType: MainScreenModel.SectionType = .coin
    
    let mainScreenModel = MainScreenModel(
      isDarkMode: nil,
      isPremium: false,
      allSections: [
        .init(type: sectionType, isEnabled: false, isHidden: false, isPremium: false, advLabel: .none)
      ])
    let expectation = expectation(description: "validate purchase called")
    let storageServiceMock = services.storageService as? StorageServiceMock
    
    // Act
    storageServiceMock?.saveData(mainScreenModel)
    storageServiceMock?.saveDataStub = { result in
      receivedStorageModel = result as? MainScreenModel
      expectation.fulfill()
    }
    interactor.addLabel(advLabel, for: sectionType)
    wait(for: [expectation], timeout: 1)
    
    // Assert
    let section = receivedStorageModel?.allSections.filter({ $0.type == sectionType }).first
    XCTAssertTrue(section?.advLabel == advLabel)
  }
}
