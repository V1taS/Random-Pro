//
//  UpdateAppScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// Сборщик `UpdateAppScreen`
final class UpdateAppScreenAssembly {
  
  /// Собирает модуль `UpdateAppScreen`
  /// - Returns: Cобранный модуль `UpdateAppScreen`
  func createModule() -> UpdateAppScreenModule {
    
    let interactor = UpdateAppScreenInteractor()
    let view = UpdateAppScreenView()
    let factory = UpdateAppScreenFactory()
    let presenter = UpdateAppScreenViewController(moduleView: view,
                                                  interactor: interactor,
                                                  factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
