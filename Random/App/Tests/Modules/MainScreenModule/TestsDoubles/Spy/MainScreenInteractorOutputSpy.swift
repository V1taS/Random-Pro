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
  
  // MARK: - Spy variables to check if the methods were called
  
  var didReceiveModelCalled = false
  
  // MARK: - Stub variables to mimic the returned values
  
  var didReceiveModelCompletion: ((MainScreenModel) -> Void)?
  
  // MARK: - MainScreenInteractorOutput
  
  func didReceive(model: MainScreenModel) {
    didReceiveModelCalled = true
    didReceiveModelCompletion?(model)
  }
}
