//
//  PremiumScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// Сборщик `PremiumScreen`
public final class PremiumScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `PremiumScreen`
  /// - Parameters:
  ///  - appPurchasesService: Сервис работы с подписками
  /// - Returns: Cобранный модуль `PremiumScreen`
  public func createModule(appPurchasesService: PremiumScreenAppPurchasesServiceProtocol) -> PremiumScreenModule {
    let interactor = PremiumScreenInteractor(appPurchasesService: appPurchasesService)
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
