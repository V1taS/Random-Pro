//
//  BottleScreenInteractorTests.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 08.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random_Pro

final class BottleScreenInteractorTests: XCTestCase {
  
  // MARK: - Private property
  
  private var sut: BottleScreenInteractor!
  private let outputSpy = BottleScreenInteractorOutputSpy()
  
  // MARK: - Initialization
  
  override func setUp() {
    super.setUp()
    
    sut = BottleScreenInteractor(TimerServiceMock())
    sut.output = outputSpy
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }

  func testGivenRotatingBottleWhenFinishedRandomRotationTimeThenStopBottleRotation() {
    // Arrange
    var isStopBottleRotation = false
    
    /// Ожидает выполнения какое-то врея
    let expectation = XCTestExpectation(description: "Wait for output call")
    
    outputSpy.stopBottleRotationStub = {
      isStopBottleRotation = true
      
      /// Говорим что мы закончили выполнение
      expectation.fulfill()
    }
    
    // Act
    sut.generatesBottleRotationTimeAction()
    wait(for: [expectation], timeout: 2)
    
    // Assert
    XCTAssertTrue(isStopBottleRotation)
  }
}
