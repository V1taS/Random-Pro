//
//  CubesStyleSelectionScreenAssembly.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// Сборщик `CubesStyleSelectionScreen`
final class CubesStyleSelectionScreenAssembly {
  
  /// Собирает модуль `CubesStyleSelectionScreen`
  /// - Returns: Cобранный модуль `CubesStyleSelectionScreen`
  func createModule(services: ApplicationServices) -> CubesStyleSelectionScreenModule {
    let interactor = CubesStyleSelectionScreenInteractor(services: services)
    let view = CubesStyleSelectionScreenView()
    let factory = CubesStyleSelectionScreenFactory()
    let presenter = CubesStyleSelectionScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
