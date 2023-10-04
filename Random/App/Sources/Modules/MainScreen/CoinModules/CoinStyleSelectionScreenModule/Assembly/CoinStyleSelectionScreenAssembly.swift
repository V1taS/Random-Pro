//
//  CoinStyleSelectionScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import Foundation

/// Сборщик `CoinStyleSelectionScreen`
public final class CoinStyleSelectionScreenAssembly {

  public init() {}
  
  /// Собирает модуль `CoinStyleSelectionScreen`
  /// - Returns: Cобранный модуль `CoinStyleSelectionScreen`
  func createModule(services: ApplicationServices) -> CoinStyleSelectionScreenModule {
    let interactor = CoinStyleSelectionScreenInteractor(services: services)
    let view = CoinStyleSelectionScreenView()
    let factory = CoinStyleSelectionScreenFactory()
    let presenter = CoinStyleSelectionScreenViewController(
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
