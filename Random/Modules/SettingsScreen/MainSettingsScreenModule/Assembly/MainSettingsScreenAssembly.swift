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
  func createModule() -> MainSettingsScreenModule {
    
    let interactor = MainSettingsScreenInteractor()
    let view = MainSettingsScreenView()
    let factory = MainSettingsScreenFactory()
    let presenter = MainSettingsScreenViewController(interactor: interactor,
                                                     moduleView: view,
                                                     factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
