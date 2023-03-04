//
//  PlayerCardSelectionScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import Foundation

/// Сборщик `PlayerCardSelectionScreen`
public final class PlayerCardSelectionScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `PlayerCardSelectionScreen`
  /// - Returns: Cобранный модуль `PlayerCardSelectionScreen`
  public func createModule(storageService: StorageServiceProtocol) -> PlayerCardSelectionScreenModule {
    let interactor = PlayerCardSelectionScreenInteractor(storageService: storageService)
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
