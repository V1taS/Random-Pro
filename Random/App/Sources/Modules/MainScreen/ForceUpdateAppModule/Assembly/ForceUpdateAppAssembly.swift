//
//  ForceUpdateAppAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import Foundation

/// Сборщик `ForceUpdateApp`
final class ForceUpdateAppAssembly {
  
  init() {}
  
  /// Собирает модуль `ForceUpdateApp`
  /// - Returns: Cобранный модуль `ForceUpdateApp`
  func createModule(services: ApplicationServices) -> ForceUpdateAppModule {
    let interactor = ForceUpdateAppInteractor()
    let view = ForceUpdateAppView()
    let factory = ForceUpdateAppFactory()
    let presenter = ForceUpdateAppViewController(
      moduleView: view,
      interactor: interactor,
      factory: factory,
      services: services
    )
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
