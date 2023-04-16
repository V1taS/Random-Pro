//
//  NumberScreenModuleIntegrationTests.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import XCTest
@testable import Random

final class NumberScreenModuleIntegrationTests: XCTestCase {
  
  // MARK: - Private property
  
  // System under test (Тестируемая система)
  private var sut: NumberScreenViewController!
  
  private var interactor: NumberScreenInteractorInputMock!
  private var factory: NumberScreenFactoryInputMock!
  private var view: NumberScreenViewInputMock!
  
  // MARK: - Производим инициализацию объектов для тестирования
  
  override func setUp() {
    super.setUp()
    
    view = NumberScreenViewInputMock()
    interactor = NumberScreenInteractorInputMock()
    factory = NumberScreenFactoryInputMock()
    sut = NumberScreenViewController(moduleView: view,
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
  
  func testViewDidLoad() {
    // Act
    sut.viewDidLoad()
    
    // Assert
    XCTAssertTrue(interactor.isGetContent)
  }
  
  func testWithoutRepetitionAction() {
    // Act
    sut.withoutRepetitionAction(isOn: true)
    
    // Assert
    XCTAssertTrue(interactor.isWithoutRepetitionAction)
  }
  
  func testCleanButtonAction() {
    // Act
    sut.cleanButtonAction()
    
    // Assert
    XCTAssertTrue(interactor.isCleanButtonAction)
  }
  
  func testReturnListResult() {
    // Act
    _ = sut.returnListResult()
    
    // Assert
    XCTAssertTrue(interactor.isReturnListResult)
  }
  
  func testRangeStartDidChange() {
    // Act
    sut.rangeStartDidChange(nil)
    
    // Assert
    XCTAssertTrue(interactor.isRangeStartDidChange)
  }
  
  func testRangeEndDidChange() {
    // Act
    sut.rangeEndDidChange(nil)
    
    // Assert
    XCTAssertTrue(interactor.isRangeEndDidChange)
  }
  
  func testGenerateButtonAction() {
    // Act
    sut.generateButtonAction(rangeStartValue: nil, rangeEndValue: nil)
    
    // Assert
    XCTAssertTrue(interactor.isGenerateContent)
  }
  
  func testDidReverseListResult() {
    // Act
    sut.didReverse(listResult: [])
    
    // Assert
    XCTAssertTrue(view.isSetListResult)
  }
  
  func testDidReceiveModel() {
    // Arrange
    let model = NumberScreenModel(rangeStartValue: nil,
                                  rangeEndValue: nil,
                                  result: "",
                                  listResult: [],
                                  isEnabledWithoutRepetition: false)
    
    // Act
    sut.didReceive(model: model)
    
    // Assert
    XCTAssertTrue(factory.isReverse)
    XCTAssertTrue(view.isSetResult)
    XCTAssertTrue(view.isSetRangeStart)
    XCTAssertTrue(view.isSetRangeEnd)
  }
  
  func testDidReceiveRangeStart() {
    // Act
    sut.didReceiveRangeStart(text: nil)
    
    // Assert
    XCTAssertTrue(view.isSetRangeStart)
  }
  
  func testDidReceiveRangeEnd() {
    // Act
    sut.didReceiveRangeEnd(text: nil)
    
    // Assert
    XCTAssertTrue(view.isSetRangeEnd)
  }
}
