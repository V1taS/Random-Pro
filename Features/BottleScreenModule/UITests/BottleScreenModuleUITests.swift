//
//  BottleScreenModuleUITests.swift
//  BottleScreenModule
//
//  Created by Sosin_Vitalii on 24/02/2023.
//  Copyright © 2023 Sosin Vitalii. All rights reserved.
//

@testable import BottleScreenModule
import XCTest

final class BottleScreenModuleUITests: XCTestCase {
  let app = XCUIApplication()
  override func setUpWithError() throws {
    super.setUp()
    continueAfterFailure = false
    app.launchArguments += ["UITesting"]
    app.launch()
    print(app.debugDescription)
  }
  override func tearDownWithError() throws {
    super.tearDown()
  }
  func testApp() {
    // Given
    // When
    // Then
  }
}
