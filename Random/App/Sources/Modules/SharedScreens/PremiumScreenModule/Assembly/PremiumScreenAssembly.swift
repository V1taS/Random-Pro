//
//  PremiumScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import SKAbstractions

/// Сборщик `PremiumScreen`
final class PremiumScreenAssembly {
  
  /// Собирает модуль `PremiumScreen`
  /// - Parameters:
  ///  - appPurchasesService: Сервис работы с подписками
  ///  - services: Сервисы приложения
  /// - Returns: Cобранный модуль `PremiumScreen`
  func createModule(_ appPurchasesService: IAppPurchasesService,
                    services: ApplicationServices) -> PremiumScreenModule {
    let interactor = PremiumScreenInteractor(appPurchasesService, services: services)
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
