//
//  ShareScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit
import SKAbstractions

/// Сборщик `ShareScreen`
final class ShareScreenAssembly {
  
  /// Собирает модуль `ShareScreen`
  /// - Parameter permissionService: Сервис по работе с разрешениями
  /// - Returns: Cобранный модуль `ShareScreen`
  func createModule(permissionService: PermissionService) -> ShareScreenModule {
    let interactor = ShareScreenInteractor(permissionService: permissionService)
    let view = ShareScreenView()
    let factory = ShareScreenFactory()
    
    let presenter = ShareScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
