//
//  SlogansScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//

import Foundation

/// Сборщик `SlogansScreen`
final class SlogansScreenAssembly {
  
  /// Собирает модуль `SlogansScreen`
  /// - Returns: Cобранный модуль `SlogansScreen`
  func createModule(_ services: ApplicationServices) -> SlogansScreenModule {
    let interactor = SlogansScreenInteractor(services: services)
    let view = SlogansScreenView()
    let factory = SlogansScreenFactory()
    let presenter = SlogansScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
