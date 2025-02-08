//
//  ButtonCounterService.swift
//  Random
//
//  Created by Vitalii Sosin on 30.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

public final class ButtonCounterServiceImpl: ButtonCounterService {
  public init() {}

  // MARK: - Internal properties
  
  public var clickResponse: ((_ clickCount: Int) -> Void)?

  // MARK: - Private properties
  
  private var storageCounter: Int {
    get {
      UserDefaults.standard.integer(forKey: Appearance().userDefaultsKey)
    } set {
      UserDefaults.standard.set(newValue, forKey: Appearance().userDefaultsKey)
    }
  }
  
  // MARK: - Private func
  
  public func onButtonClick() {
    storageCounter += 1
    clickResponse?(storageCounter)
  }
}

// MARK: - Appearance

private extension ButtonCounterServiceImpl {
  struct Appearance {
    let userDefaultsKey = "button_counter_service"
  }
}
