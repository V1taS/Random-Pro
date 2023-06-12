//
//  TruthOrDareScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import Foundation

/// Сборщик `TruthOrDareScreen`
final class TruthOrDareScreenAssembly {
  
  /// Собирает модуль `TruthOrDareScreen`
  /// - Returns: Cобранный модуль `TruthOrDareScreen`
  func createModule(services: ApplicationServices) -> TruthOrDareScreenModule {
    let interactor = TruthOrDareScreenInteractor(services: services)
    let view = TruthOrDareScreenView()
    let factory = TruthOrDareScreenFactory()
    let presenter = TruthOrDareScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
