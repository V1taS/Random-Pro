//
//  NumberScreenInteractorOutputSpy.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 01.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random

final class NumberScreenInteractorOutputSpy: NumberScreenInteractorOutput {
  
  // MARK: - Stub (Возвращают набор предопределенных данных)
  
  var didReceiveModelStub: ((_ model: NumberScreenModel) -> Void)?
  var didReceiveRangeStartTextStub: ((_ text: String?) -> Void)?
  var didReceiveRangeEndTextStub: ((_ text: String?) -> Void)?
  var cleanButtonWasSelectedModelStub: ((_ model: NumberScreenModel) -> Void)?
  var didReceiveRangeEndedStub: (() -> Void)?
  var didReceiveRangeErrorStub: (() -> Void)?
  
  // MARK: - NumberScreenInteractorOutput
  
  func didReceive(model: NumberScreenModel) {
    didReceiveModelStub?(model)
  }
  
  func didReceiveRangeStart(text: String?) {
    didReceiveRangeStartTextStub?(text)
  }
  
  func didReceiveRangeEnd(text: String?) {
    didReceiveRangeEndTextStub?(text)
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    cleanButtonWasSelectedModelStub?(model)
  }
  
  func didReceiveRangeEnded() {
    didReceiveRangeEndedStub?()
  }
  
  func didReceiveRangeError() {
    didReceiveRangeErrorStub?()
  }
}
