//
//  MainScreenInteractorTests.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import XCTest
@testable import Random_Pro

final class MainScreenInteractorTests: XCTestCase {
  
  // MARK: - Private property
  
  private var sut: MainScreenInteractor!
  private let outputSpy = MainScreenInteractorOutputSpy()
  @ObjectCustomUserDefaultsWrapper<MainScreenModel>(key: Appearance().keyUserDefaults)
  private var localSaveModel: MainScreenModel?
  
  // MARK: - Производим инициализацию объектов для тестирования
  
  override func setUp() {
    super.setUp()
    
    sut = MainScreenInteractor()
    sut.output = outputSpy
  }
  
  // MARK: - Освождаем ресурсы
  
  override func tearDown() {
    sut = nil
    localSaveModel = nil
    super.tearDown()
  }
  
  // MARK: - Тестируем
  
  func testGivenFirstStartAppWhenGetContentThenSendModelToOutput() {
    // Arrange
    localSaveModel = nil
    let firstStartAppModel = createBaseModelRusLang()
    var recievedModel: MainScreenModel?
    
    // Ожидает выполнения какое-то врея
    let expectation = XCTestExpectation(description: "Wait for output call")
    
    outputSpy.didReceiveModelStub = { model in
      recievedModel = model
      expectation.fulfill()
    }
    
    // Act
    sut.getContent()
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(firstStartAppModel, recievedModel)
  }
  
  func testGivenSecondStartWithRusLangAppWhenGetContentThenSendModelToOutput() {
    // Arrange
    localSaveModel = createBaseModelRusLang()
    let firstStartAppModel = createBaseModelRusLang()
    var recievedModel: MainScreenModel?
    
    // Ожидает выполнения какое-то врея
    let expectation = XCTestExpectation(description: "Wait for output call")
    
    outputSpy.didReceiveModelStub = { model in
      recievedModel = model
      expectation.fulfill()
    }
    
    // Act
    sut.getContent()
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(firstStartAppModel, recievedModel)
  }
  
  func testGivenSecondStartWithEngLangAppWhenGetContentThenSendModelToOutput() {
    // Arrange
    localSaveModel = createBaseModelEngLang()
    let firstStartAppModel = createBaseModelRusLang()
    var recievedModel: MainScreenModel?
    
    // Ожидает выполнения какое-то врея
    let expectation = XCTestExpectation(description: "Wait for output call")
    
    outputSpy.didReceiveModelStub = { model in
      recievedModel = model
      expectation.fulfill()
    }
    
    // Act
    sut.getContent()
    wait(for: [expectation], timeout: 1)
    
    // Assert
    XCTAssertEqual(firstStartAppModel, recievedModel)
  }
  
  // swiftlint:disable all
  func testGivenDifferentNumberOfSectionsWhenGetContentThenSendModelToOutput() {
    // TODO: -
  }
  
  func testGivenAddedNewSectionWhenGetContentThenSendModelToOutput() {
    // TODO: -
  }
}
