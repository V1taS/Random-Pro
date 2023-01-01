//
//  MainScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// Сборщик `MainScreen`
final class MainScreenAssembly {
  
  /// Собирает модуль `MainScreen`
  /// - Parameters:
  ///  - services: Сервисы приложения
  /// - Returns: Cобранный модуль `MainScreen`
  func createModule(_ services: ApplicationServices) -> MainScreenModule {
    let interactor = MainScreenInteractor(services: services)
    let view = MainScreenView()
    let factory = MainScreenFactory()
    let presenter = MainScreenViewController(moduleView: view,
                                             interactor: interactor,
                                             factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
