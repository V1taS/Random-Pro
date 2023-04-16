//
//  BottleScreenInteractorOutputSpy.swift
//  Random Pro Tests
//
//  Created by Tatyana Sosina on 08.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
@testable import Random

final class BottleScreenInteractorOutputSpy: BottleScreenInteractorOutput {
  
  // MARK: - Stub (Возвращают набор предопределенных данных)
  
  var stopBottleRotationStub: (() -> Void)?
  var tactileFeedbackBottleRotatesStub: (() -> Void)?
  
  // MARK: - BottleScreenInteractorOutput
  
  func stopBottleRotation() {
    stopBottleRotationStub?()
  }
  
  func tactileFeedbackBottleRotates() {
    tactileFeedbackBottleRotatesStub?()
  }
}
