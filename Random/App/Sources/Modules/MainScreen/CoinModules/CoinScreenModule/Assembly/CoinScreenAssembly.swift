//
//  CoinScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

final class CoinScreenAssembly {
  
  /// Создает  модуль `CoinScreen`
  /// - Parameters:
  ///  - hapticService: Обратная связь от моторчика
  ///  - services: Сервисы приложения
  func createModule(hapticService: HapticService,
                    services: ApplicationServices) -> CoinScreenModule {
    let view = CoinScreenView()
    let interactor = CoinScreenInteractor(hapticService: hapticService,
                                          services: services)
    let factory = CoinScreenFactory()
    let presenter = CoinScreenViewController(moduleView: view,
                                             interactor: interactor,
                                             factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
