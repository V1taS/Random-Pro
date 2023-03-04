//
//  TeamsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// Сборщик `TeamsScreen`
public final class TeamsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `TeamsScreen`
  /// - Returns: Cобранный модуль `TeamsScreen`
  public func createModule(storageService: StorageServiceProtocol) -> TeamsScreenModule {
    let interactor = TeamsScreenInteractor(storageService: storageService)
    let view = TeamsScreenView()
    let factory = TeamsScreenFactory(storageService: storageService)
    let presenter = TeamsScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
