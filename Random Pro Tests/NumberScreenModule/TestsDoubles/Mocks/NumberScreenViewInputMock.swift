//
//  NumberScreenViewInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random_Pro

/// Mock View Input
final class NumberScreenViewInputMock: NumberScreenViewProtocol {
  
  // MARK: - Флаги вызовов функция
  
  var isSetResult: Bool = false
  var isSetListResult: Bool = false
  var isSetRangeStart: Bool = false
  var isSetRangeEnd: Bool = false
  
  // MARK: - Init
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - NumberScreenFactoryInput
  
  func set(result: String?) {
    isSetResult = true
  }
  
  func set(listResult: [String]) {
    isSetListResult = true
  }
  
  func setRangeStart(_ text: String?) {
    isSetRangeStart = true
  }
  
  func setRangeEnd(_ text: String?) {
    isSetRangeEnd = true
  }
}
