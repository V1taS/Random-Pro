//
//  SeriesScreenAssembly.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//

import Foundation

/// Сборщик `SeriesScreen`
public final class SeriesScreenAssembly {

  public init() {}
  
  /// Собирает модуль `SeriesScreen`
  /// - Returns: Cобранный модуль `SeriesScreen`
  public func createModule() -> SeriesScreenModule {
    let interactor = SeriesScreenInteractor()
    let view = SeriesScreenView()
    let factory = SeriesScreenFactory()
    let presenter = SeriesScreenViewController(
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
