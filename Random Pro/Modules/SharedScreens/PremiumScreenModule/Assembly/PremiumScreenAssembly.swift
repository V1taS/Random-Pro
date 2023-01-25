//
//  PremiumScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// Сборщик `PremiumScreen`
final class PremiumScreenAssembly {
  
  /// Собирает модуль `PremiumScreen`
  /// - Parameter appPurchasesService: Сервис работы с подписками
  /// - Returns: Cобранный модуль `PremiumScreen`
  func createModule(_ appPurchasesService: AppPurchasesService) -> PremiumScreenModule {
    let interactor = PremiumScreenInteractor(appPurchasesService)
    let view = PremiumScreenView()
    let factory = PremiumScreenFactory()
    let presenter = PremiumScreenViewController(moduleView: view,
                                                interactor: interactor,
                                                factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
