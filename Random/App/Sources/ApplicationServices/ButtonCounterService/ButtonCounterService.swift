//
//  ButtonCounterService.swift
//  Random
//
//  Created by Vitalii Sosin on 30.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol ButtonCounterService {
  
  /// Действие на нажатие кнопки
  var clickResponse: ((_ clickCount: Int) -> Void)? { get set }
  
  /// Сохраняем нажатие
  func onButtonClick()
}

final class ButtonCounterServiceImpl: ButtonCounterService {
  
  // MARK: - Internal properties
  
  var clickResponse: ((_ clickCount: Int) -> Void)?
  
  // MARK: - Private properties
  
  private var storageCounter: Int {
    get {
      UserDefaults.standard.integer(forKey: Appearance().userDefaultsKey)
    } set {
      UserDefaults.standard.set(newValue, forKey: Appearance().userDefaultsKey)
    }
  }
  
  // MARK: - Private func
  
  func onButtonClick() {
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
