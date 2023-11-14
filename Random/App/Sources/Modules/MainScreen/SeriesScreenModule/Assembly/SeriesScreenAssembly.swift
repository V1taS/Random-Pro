//
//  SeriesScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import Foundation

/// Сборщик `SeriesScreen`
final class SeriesScreenAssembly {

//  public init() {}
  
  /// Собирает модуль `SeriesScreen`
  /// - Parameter services: Сервисы приложения
  /// - Returns: Cобранный модуль `SeriesScreen`
  func createModule(services: ApplicationServices) -> SeriesScreenModule {
    let view = SeriesScreenView()
    let factory = SeriesScreenFactory()
    let interactor = SeriesScreenInteractor(services: services, factory: factory)
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
