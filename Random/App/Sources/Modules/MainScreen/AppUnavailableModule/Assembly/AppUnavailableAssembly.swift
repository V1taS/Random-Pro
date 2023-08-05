//
//  AppUnavailableAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import Foundation

/// Сборщик `AppUnavailable`
final class AppUnavailableAssembly {

  public init() {}
  
  /// Собирает модуль `AppUnavailable`
  /// - Returns: Cобранный модуль `AppUnavailable`
  func createModule(services: ApplicationServices) -> AppUnavailableModule {
    let interactor = AppUnavailableInteractor()
    let view = AppUnavailableView()
    let factory = AppUnavailableFactory()
    let presenter = AppUnavailableViewController(
      moduleView: view,
      interactor: interactor,
      factory: factory, services: services
    )
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
