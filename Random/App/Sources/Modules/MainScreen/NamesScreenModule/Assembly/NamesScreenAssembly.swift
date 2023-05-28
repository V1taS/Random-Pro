//
//  NamesScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit

/// Сборщик `NamesScreen`
final class NamesScreenAssembly {
  
  /// Собирает модуль `NamesScreen`
  /// - Returns: Cобранный модуль `NamesScreen`
  func createModule(services: ApplicationServices) -> NamesScreenModule {
    let interactor = NamesScreenInteractor(services: services)
    let view = NamesScreenView()
    let factory = NamesScreenFactory()
    let presenter = NamesScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
