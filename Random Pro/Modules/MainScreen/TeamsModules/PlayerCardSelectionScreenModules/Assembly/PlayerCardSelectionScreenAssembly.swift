//
//  PlayerCardSelectionScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit

/// Сборщик `PlayerCardSelectionScreen`
final class PlayerCardSelectionScreenAssembly {
  
  /// Собирает модуль `PlayerCardSelectionScreen`
  /// - Returns: Cобранный модуль `PlayerCardSelectionScreen`
  func createModule(services: ApplicationServices) -> PlayerCardSelectionScreenModule {
    let interactor = PlayerCardSelectionScreenInteractor(services: services)
    let view = PlayerCardSelectionScreenView()
    let factory = PlayerCardSelectionScreenFactory()
    let presenter = PlayerCardSelectionScreenViewController(moduleView: view,
                                                            interactor: interactor,
                                                            factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
