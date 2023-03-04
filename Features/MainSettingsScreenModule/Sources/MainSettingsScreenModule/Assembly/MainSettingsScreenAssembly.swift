//
//  MainSettingsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// Сборщик `MainSettingsScreen`
public final class MainSettingsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `MainSettingsScreen`
  /// - Returns: Cобранный модуль `MainSettingsScreen`
  public func createModule() -> MainSettingsScreenModule {
    let interactor = MainSettingsScreenInteractor()
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