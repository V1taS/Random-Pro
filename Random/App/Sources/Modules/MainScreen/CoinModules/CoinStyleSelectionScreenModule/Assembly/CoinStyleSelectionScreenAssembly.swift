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
  public func createModule() -> CoinStyleSelectionScreenModule {
    let interactor = CoinStyleSelectionScreenInteractor()
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
