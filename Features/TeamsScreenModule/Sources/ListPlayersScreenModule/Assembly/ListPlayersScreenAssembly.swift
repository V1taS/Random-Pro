//
//  ListPlayersScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import Foundation

/// Сборщик `ListPlayersScreen`
public final class ListPlayersScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `ListPlayersScreen`
  /// - Returns: Cобранный модуль `ListPlayersScreen`
  public func createModule(storageService: StorageServiceProtocol) -> ListPlayersScreenModule {
    let interactor = ListPlayersScreenInteractor(storageService: storageService)
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
