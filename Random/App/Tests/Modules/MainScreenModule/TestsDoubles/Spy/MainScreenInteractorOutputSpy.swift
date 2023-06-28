//
//  MainScreenInteractorOutputSpy.swift
//  Random Pro Tests
//
//  Created by Vitalii Sosin on 27.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

@testable
import Random

final class MainScreenInteractorOutputSpy: MainScreenInteractorOutput {
  
  // MARK: - Spy variables
  
  var didReceiveModelCalled = false
  var receivedModel: MainScreenModel?
  
  // MARK: - MainScreenInteractorOutput
  
  func didReceive(model: MainScreenModel) {
    didReceiveModelCalled = true
    receivedModel = model
  }
}
