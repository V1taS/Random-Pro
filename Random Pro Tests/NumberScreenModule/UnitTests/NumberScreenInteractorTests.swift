//
//  NumberScreenInteractorTests.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random_Pro

// Given When Then (Дано Когда Тогда)
final class NumberScreenInteractorTests: XCTestCase {
  
  // MARK: - Private property
  
  // System under test (Тестируемая система)
  private var sut: NumberScreenInteractor!
  private let outputSpy = NumberScreenInteractorOutputSpy()

  // MARK: - Производим инициализацию объектов для тестирования
  
  override func setUp() {
    super.setUp()
    
    sut = NumberScreenInteractor()
    sut.output = outputSpy
  }
  
  // MARK: - Освождаем ресурсы
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
  // MARK: - Тестируем
  
  func testGivenEmptyModelWhenGetContentThenSendModelToOutput() {
    // Arrange
    let emptyModel = NumberScreenModel(
      rangeStartValue: "1",
      rangeEndValue: "10",
      result: "?",
      listResult: [],
      isEnabledWithoutRepetition: false
    )
    
    var recievedModel: NumberScreenModel?
    let expectation = XCTestExpectation(description: "Wait for output call")
    
    outputSpy.didReceiveModelStub = { model in
      recievedModel = model
      expectation.fulfill()
    }
    
    // Act
    sut.getContent(withWithoutRepetition: false)
    wait(for: [expectation], timeout: 2)
    
    // Assert
    XCTAssertEqual(emptyModel, recievedModel)
  }
  
  func testGivenWithoutRepetitionToggleWhenChangeToggleThenSendModelToOutput() {
    // Arrange
    let isEnabledWithoutRepetition = true
    
    var recievedIsEnabledWithoutRepetition: Bool?
    let expectation = XCTestExpectation(description: "Wait for output call")
    outputSpy.didReceiveModelStub = { model in
      recievedIsEnabledWithoutRepetition = model.isEnabledWithoutRepetition
      expectation.fulfill()
    }
    
    // Act
    sut.withoutRepetitionAction(isOn: true)
    wait(for: [expectation], timeout: 2)
    
    // Assert
    XCTAssertEqual(isEnabledWithoutRepetition, recievedIsEnabledWithoutRepetition)
  }
  
  func testGivenEmptyModelWhenCleanButtonTappedThenSendModelToOutput() {
    // Arrange
    let emptyModel = NumberScreenModel(
      rangeStartValue: "1",
      rangeEndValue: "10",
      result: "?",
      listResult: [],
      isEnabledWithoutRepetition: false
    )
    
    var recievedModel: NumberScreenModel?
    let expectation = XCTestExpectation(description: "Wait for output call")
    outputSpy.didReceiveModelStub = { model in
      recievedModel = model
      expectation.fulfill()
    }
    
    // Act
    sut.cleanButtonAction()
    wait(for: [expectation], timeout: 2)
    
    // Assert
    XCTAssertEqual(emptyModel, recievedModel)
  }
}
