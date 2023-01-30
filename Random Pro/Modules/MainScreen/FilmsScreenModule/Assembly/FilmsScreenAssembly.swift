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
  /// - Returns: Cобранный модуль `FilmsScreen`
  func createModule() -> FilmsScreenModule {
    let interactor = FilmsScreenInteractor()
    let view = FilmsScreenView()
    let factory = FilmsScreenFactory()
    let presenter = FilmsScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
