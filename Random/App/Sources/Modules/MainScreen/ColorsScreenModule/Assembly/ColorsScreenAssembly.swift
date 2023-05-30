//
//  ColorsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit

/// Сборщик `ColorsScreen`
final class ColorsScreenAssembly {
  
  /// Собирает модуль `ColorsScreen`
  /// - Parameter services: Сервисы приложения
  /// - Returns: Cобранный модуль `ColorsScreen`
  func createModule(services: ApplicationServices) -> ColorsScreenModule {
    let interactor = ColorsScreenInteractor(services: services)
    let view = ColorsScreenView()
    let factory = ColorsScreenFactory()
    let presenter = ColorsScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
