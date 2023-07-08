//
//  MemesScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 08.07.2023.
//

import UIKit

/// Сборщик `MemesScreen`
final class MemesScreenAssembly {
  
  /// Собирает модуль `MemesScreen`
  /// - Returns: Cобранный модуль `MemesScreen`
  func createModule(_ services: ApplicationServices) -> MemesScreenModule {
    let interactor = MemesScreenInteractor()
    let view = MemesScreenView()
    let factory = MemesScreenFactory()
    let presenter = MemesScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
