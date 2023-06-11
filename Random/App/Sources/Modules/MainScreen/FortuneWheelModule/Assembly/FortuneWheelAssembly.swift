//
//  FortuneWheelAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit

/// Сборщик `FortuneWheel`
final class FortuneWheelAssembly {
  
  /// Собирает модуль `FortuneWheel`
  /// - Returns: Cобранный модуль `FortuneWheel`
  func createModule(services: ApplicationServices) -> FortuneWheelModule {
    let interactor = FortuneWheelInteractor()
    let view = FortuneWheelView()
    let factory = FortuneWheelFactory()
    let presenter = FortuneWheelViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
