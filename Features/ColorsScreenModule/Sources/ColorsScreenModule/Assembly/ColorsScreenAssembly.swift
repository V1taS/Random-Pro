//
//  ColorsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 11.09.2022.
//

import UIKit

/// Сборщик `ColorsScreen`
public final class ColorsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `ColorsScreen`
  /// - Parameter permissionService: Сервис по работе с разрешениями
  /// - Returns: Cобранный модуль `ColorsScreen`
  public func createModule(permissionService: PermissionServiceProtocol) -> ColorsScreenModule {
    let interactor = ColorsScreenInteractor(permissionService: permissionService)
    let view = ColorsScreenView()
    let factory = ColorsScreenFactory()
    let presenter = ColorsScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}