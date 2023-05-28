//
//  CongratulationsScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit

/// Сборщик `CongratulationsScreen`
final class CongratulationsScreenAssembly {
  
  /// Собирает модуль `CongratulationsScreen`
  /// - Returns: Cобранный модуль `CongratulationsScreen`
  func createModule(services: ApplicationServices) -> CongratulationsScreenModule {
    let interactor = CongratulationsScreenInteractor(services: services)
    let view = CongratulationsScreenView()
    let factory = CongratulationsScreenFactory()
    let presenter = CongratulationsScreenViewController(moduleView: view,
                                                        interactor: interactor,
                                                        factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
