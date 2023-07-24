//
//  MainSettingsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// Сборщик `MainSettingsScreen`
final class MainSettingsScreenAssembly {
  
  /// Собирает модуль `MainSettingsScreen`
  /// - Returns: Cобранный модуль `MainSettingsScreen`
  func createModule(services: ApplicationServices) -> MainSettingsScreenModule {
    let interactor = MainSettingsScreenInteractor(services: services)
    let view = MainSettingsScreenView()
    let factory = MainSettingsScreenFactory()
    let presenter = MainSettingsScreenViewController(moduleView: view,
                                                     interactor: interactor,
                                                     factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
