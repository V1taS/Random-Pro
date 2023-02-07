//
//  ListPlayersScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit

/// Сборщик `ListPlayersScreen`
final class ListPlayersScreenAssembly {
  
  /// Собирает модуль `ListPlayersScreen`
  /// - Returns: Cобранный модуль `ListPlayersScreen`
  func createModule(services: ApplicationServices) -> ListPlayersScreenModule {
    let interactor = ListPlayersScreenInteractor(services: services)
    let view = ListPlayersScreenView()
    let factory = ListPlayersScreenFactory()
    let presenter = ListPlayersScreenViewController(moduleView: view,
                                                    interactor: interactor,
                                                    factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
