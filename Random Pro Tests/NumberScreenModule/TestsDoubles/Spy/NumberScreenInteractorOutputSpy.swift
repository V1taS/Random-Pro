//
//  NumberScreenInteractorOutputSpy.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random_Pro

final class NumberScreenInteractorOutputSpy: NumberScreenInteractorOutput {
  
  // MARK: - Stub (Возвращают набор предопределенных данных)
  
  var didReciveModelStub: ((_ model: NumberScreenModel) -> Void)?
  var didReciveRangeStartTextStub: ((_ text: String?) -> Void)?
  var didReciveRangeEndTextStub: ((_ text: String?) -> Void)?
  var cleanButtonWasSelectedModelStub: ((_ model: NumberScreenModel) -> Void)?
  var didReciveRangeEndedStub: (() -> Void)?
  var didReciveRangeErrorStub: (() -> Void)?
  
  // MARK: - NumberScreenInteractorOutput
  
  func didRecive(model: NumberScreenModel) {
    didReciveModelStub?(model)
  }
  
  func didReciveRangeStart(text: String?) {
    didReciveRangeStartTextStub?(text)
  }
  
  func didReciveRangeEnd(text: String?) {
    didReciveRangeEndTextStub?(text)
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    cleanButtonWasSelectedModelStub?(model)
  }
  
  func didReciveRangeEnded() {
    didReciveRangeEndedStub?()
  }
  
  func didReciveRangeError() {
    didReciveRangeErrorStub?()
  }
}
