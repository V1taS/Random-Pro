//
//  BottleScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class BottleScreenAssembly {
  
  /// Собирает модуль `BottleScreen`
  /// - Returns: Cобранный модуль `BottleScreen`
  func createModule(timerService: TimerService) -> BottleScreenModule {
    let view = BottleScreenView()
    let interactor = BottleScreenInteractor(timerService)
    let factory = BottleScreenFactory()
    let presenter = BottleScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
