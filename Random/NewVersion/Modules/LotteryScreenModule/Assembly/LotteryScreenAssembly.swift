//
//  LotteryScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class LotteryScreenAssembly {
  
  /// Собирает модуль `LotteryScreen`
  func createModule() -> LotteryScreenModule {
    let view = LotteryScreenView()
    let interactor = LotteryScreenInteractor()
    let factory = LotteryScreenFactory()
    let presenter = LotteryScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
