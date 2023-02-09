//
//  CubesScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Сборщик `CubesScreen`
final class CubesScreenAssembly {
  
  /// Собирает модуль `CubesScreen`
  /// - Returns: Cобранный модуль `CubesScreen`
  func createModule(services: ApplicationServices) -> CubesScreenModule {
    let view = CubesScreenView()
    let interactor = CubesScreenInteractor(services: services)
    let factory = CubesScreenFactory()
    let presenter = CubesScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
