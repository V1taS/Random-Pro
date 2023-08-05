//
//  ForceUpdateAppAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import Foundation

/// Сборщик `ForceUpdateApp`
public final class ForceUpdateAppAssembly {

  public init() {}
  
  /// Собирает модуль `ForceUpdateApp`
  /// - Returns: Cобранный модуль `ForceUpdateApp`
  public func createModule() -> ForceUpdateAppModule {
    let interactor = ForceUpdateAppInteractor()
    let view = ForceUpdateAppView()
    let factory = ForceUpdateAppFactory()
    let presenter = ForceUpdateAppViewController(
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
