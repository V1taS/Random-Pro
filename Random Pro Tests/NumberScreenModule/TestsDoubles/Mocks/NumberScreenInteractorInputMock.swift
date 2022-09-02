//
//  NumberScreenInteractorInputMock.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import XCTest
@testable import Random_Pro

/// Mock Interactor Input
final class NumberScreenInteractorInputMock: NumberScreenInteractorInput {

  // MARK: - Флаги вызовов функция
  
  var isReturnModel: Bool = false
  var isReturnListResult: Bool = false
  var isCleanButtonAction: Bool = false
  var isWithoutRepetitionAction: Bool = false
  var isGetContent: Bool = false
  var isGenerateContent: Bool = false
  var isRangeStartDidChange: Bool = false
  var isRangeEndDidChange: Bool = false
  
  // MARK: - NumberScreenInteractorInput
  
  func returnModel() -> NumberScreenModel {
    isReturnModel = true
    return NumberScreenModel(rangeStartValue: nil,
                             rangeEndValue: nil,
                             result: "",
                             listResult: [],
                             isEnabledWithoutRepetition: false)
  }
  
  func returnListResult() -> [String] {
    isReturnListResult = true
    return []
  }
  
  func cleanButtonAction() {
    isCleanButtonAction = true
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    isWithoutRepetitionAction = true
  }
  
  func getContent(withWithoutRepetition isOn: Bool) {
    isGetContent = true
  }
  
  func generateContent(firstTextFieldValue: String?, secondTextFieldValue: String?) {
    isGenerateContent = true
  }
  
  func rangeStartDidChange(_ text: String?) {
    isRangeStartDidChange = true
  }
  
  func rangeEndDidChange(_ text: String?) {
    isRangeEndDidChange = true
  }
}
