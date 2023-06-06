//
//  GiftsScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import UIKit

/// Сборщик `GiftsScreen`
final class GiftsScreenAssembly {
  
  /// Собирает модуль `GiftsScreen`
  /// - Returns: Cобранный модуль `GiftsScreen`
  func createModule(services: ApplicationServices) -> GiftsScreenModule {
    let interactor = GiftsScreenInteractor(services: services)
    let view = GiftsScreenView()
    let factory = GiftsScreenFactory()
    let presenter = GiftsScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
