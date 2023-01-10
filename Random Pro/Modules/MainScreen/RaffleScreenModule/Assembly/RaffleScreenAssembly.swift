//
//  RaffleScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.01.2023.
//

import UIKit

/// Сборщик `RaffleScreen`
final class RaffleScreenAssembly {
  
  /// Собирает модуль `RaffleScreen`
  /// - Parameter authenticationService: Сервис авторизации пользователей
  /// - Returns: Cобранный модуль `RaffleScreen`
  func createModule(authenticationService: AuthenticationService) -> RaffleScreenModule {
    let interactor = RaffleScreenInteractor(authenticationService: authenticationService)
    let view = RaffleScreenView()
    let factory = RaffleScreenFactory()
    let presenter = RaffleScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
