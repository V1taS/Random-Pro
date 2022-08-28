//
//  NumberScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Сборщик `NumberScreen`
final class NumberScreenAssembly {
  
  /// Собирает модуль `NumberScreen`
  /// - Parameter keyboardService: сервис клавиатуры
  func createModule(keyboardService: KeyboardService) -> NumberScreenModule {
    let view = NumberScreenView()
    let interactor = NumberScreenInteractor()
    let factory = NumberScreenFactory()
    let presenter = NumberScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    view.keyboardService = keyboardService
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
