//
//  BottleStyleSelectionScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import Foundation

/// Сборщик `BottleStyleSelectionScreen`
public final class BottleStyleSelectionScreenAssembly {

  public init() {}
  
  /// Собирает модуль `BottleStyleSelectionScreen`
  /// - Returns: Cобранный модуль `BottleStyleSelectionScreen`
  func createModule(services: ApplicationServices) -> BottleStyleSelectionScreenModule {
    let interactor = BottleStyleSelectionScreenInteractor(services: services)
    let view = BottleStyleSelectionScreenView()
    let factory = BottleStyleSelectionScreenFactory()
    let presenter = BottleStyleSelectionScreenViewController(
      moduleView: view,
      interactor: interactor,
      factory: factory
    )
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
