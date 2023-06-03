//
//  GoodDeedsScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit

/// Сборщик `GoodDeedsScreen`
final class GoodDeedsScreenAssembly {
  
  /// Собирает модуль `GoodDeedsScreen`
  /// - Returns: Cобранный модуль `GoodDeedsScreen`
  func createModule(_ services: ApplicationServices) -> GoodDeedsScreenModule {
    let interactor = GoodDeedsScreenInteractor(services: services)
    let view = GoodDeedsScreenView()
    let factory = GoodDeedsScreenFactory()
    let presenter = GoodDeedsScreenViewController(moduleView: view,
                                                  interactor: interactor,
                                                  factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
