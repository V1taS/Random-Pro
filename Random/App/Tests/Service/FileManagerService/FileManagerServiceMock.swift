//
//  FileManagerServiceMock.swift
//  RandomTests
//
//  Created by Vitalii Sosin on 27.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random

final class FileManagerServiceMock: FileManagerService {
  
  // Stub variables
  var saveObjectReturnURL: URL? = nil
  var readObjectReturnData: Data? = nil
  var deleteObjectShouldSucceed = false
  
  // Spy variables
  var saveObjectCallCount = 0
  var saveObjectReceivedArguments: (fileName: String, fileExtension: String, data: Data)? = nil
  var readObjectCallCount = 0
  var readObjectReceivedURL: URL? = nil
  var deleteObjectCallCount = 0
  var deleteObjectReceivedURL: URL? = nil
  
  func saveObjectWith(fileName: String, fileExtension: String, data: Data) -> URL? {
    saveObjectCallCount += 1
    saveObjectReceivedArguments = (fileName: fileName, fileExtension: fileExtension, data: data)
    return saveObjectReturnURL
  }
  
  func readObjectWith(fileURL: URL) -> Data? {
    readObjectCallCount += 1
    readObjectReceivedURL = fileURL
    return readObjectReturnData
  }
  
  func deleteObjectWith(fileURL: URL, isRemoved: ((Bool) -> Void)?) {
    deleteObjectCallCount += 1
    deleteObjectReceivedURL = fileURL
    isRemoved?(deleteObjectShouldSucceed)
  }
}
