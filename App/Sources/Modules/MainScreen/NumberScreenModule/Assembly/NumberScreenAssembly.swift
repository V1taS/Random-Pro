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
  /// - Parameters:
  ///  - services: Сервисы приложения
  func createModule(_ services: ApplicationServices) -> NumberScreenModule {
    let view = NumberScreenView()
    let interactor = NumberScreenInteractor(services: services)
    let factory = NumberScreenFactory()
    let presenter = NumberScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
