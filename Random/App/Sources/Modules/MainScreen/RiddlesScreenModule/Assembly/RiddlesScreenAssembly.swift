//
//  RiddlesScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit

/// Сборщик `RiddlesScreen`
final class RiddlesScreenAssembly {
  
  /// Собирает модуль `RiddlesScreen`
  /// - Returns: Cобранный модуль `RiddlesScreen`
  func createModule(_ services: ApplicationServices) -> RiddlesScreenModule {
    let interactor = RiddlesScreenInteractor(services: services)
    let view = RiddlesScreenView()
    let factory = RiddlesScreenFactory()
    let presenter = RiddlesScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
