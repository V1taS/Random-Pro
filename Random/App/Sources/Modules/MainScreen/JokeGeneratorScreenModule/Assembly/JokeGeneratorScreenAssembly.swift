//
//  JokeGeneratorScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit

/// Сборщик `JokeGeneratorScreen`
final class JokeGeneratorScreenAssembly {
  
  /// Собирает модуль `JokeGeneratorScreen`
  /// - Returns: Cобранный модуль `JokeGeneratorScreen`
  func createModule(_ services: ApplicationServices) -> JokeGeneratorScreenModule {
    let interactor = JokeGeneratorScreenInteractor(services: services)
    let view = JokeGeneratorScreenView()
    let factory = JokeGeneratorScreenFactory()
    let presenter = JokeGeneratorScreenViewController(moduleView: view,
                                                      interactor: interactor,
                                                      factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
