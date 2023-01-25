//
//  SelecteAppIconScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//

import UIKit

/// Сборщик `SelecteAppIconScreen`
final class SelecteAppIconScreenAssembly {
  
  /// Собирает модуль `SelecteAppIconScreen`
  /// - Returns: Cобранный модуль `SelecteAppIconScreen`
  func createModule() -> SelecteAppIconScreenModule {
    let interactor = SelecteAppIconScreenInteractor()
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
