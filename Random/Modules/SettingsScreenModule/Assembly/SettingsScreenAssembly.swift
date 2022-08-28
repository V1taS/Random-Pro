//
//  SettingsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// Сборщик `SettingsScreen`
final class SettingsScreenAssembly {
  
  /// Собирает модуль `SettingsScreen`
  /// - Returns: Cобранный модуль `SettingsScreen`
  func createModule() -> SettingsScreenModule {
    
    let interactor = SettingsScreenInteractor()
    let view = SettingsScreenView()
    let factory = SettingsScreenFactory()
    
    let presenter = SettingsScreenViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
