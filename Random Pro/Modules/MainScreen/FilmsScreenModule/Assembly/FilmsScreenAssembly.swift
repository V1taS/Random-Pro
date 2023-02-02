//
//  FilmsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// Сборщик `FilmsScreen`
final class FilmsScreenAssembly {
  
  /// Собирает модуль `FilmsScreen`
  /// - Parameter services: Сервисы приложения
  /// - Returns: Cобранный модуль `FilmsScreen`
  func createModule(services: ApplicationServices) -> FilmsScreenModule {
    let view = FilmsScreenView()
    let factory = FilmsScreenFactory()
    let interactor = FilmsScreenInteractor(services: services, factory: factory)
    let presenter = FilmsScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
