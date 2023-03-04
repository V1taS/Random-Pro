//
//  SelecteAppIconScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit

/// Сборщик `SelecteAppIconScreen`
public final class SelecteAppIconScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `SelecteAppIconScreen`
  /// - Returns: Cобранный модуль `SelecteAppIconScreen`
  public func createModule(storageService: StorageServiceProtocol) -> SelecteAppIconScreenModule {
    let interactor = SelecteAppIconScreenInteractor(storageService: storageService)
    let view = SelecteAppIconScreenView()
    let factory = SelecteAppIconScreenFactory()
    let presenter = SelecteAppIconScreenViewController(moduleView: view,
                                                       interactor: interactor,
                                                       factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
