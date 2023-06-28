//
//  UpdateAppServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class UpdateAppServiceMock: UpdateAppService {
  
  // Spy variables
  var checkIsUpdateAvailableCalled = false
  
  // Stub variables
  var updateAvailableResult: Result<Random.UpdateAppServiceModel, Random.UpdateAppServiceError>?
  
  func checkIsUpdateAvailable(
    completion: @escaping (Result<Random.UpdateAppServiceModel, Random.UpdateAppServiceError>) -> Void
  ) {
    checkIsUpdateAvailableCalled = true
    if let updateAvailableResult = updateAvailableResult {
      completion(updateAvailableResult)
    }
  }
}
