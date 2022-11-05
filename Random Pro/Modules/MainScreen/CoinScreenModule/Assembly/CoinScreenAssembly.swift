//
//  CoinScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class CoinScreenAssembly {
  
  /// Создает  модуль `CoinScreen`
  func createModule() -> CoinScreenModule {
    let view = CoinScreenView()
    let interactor = CoinScreenInteractor()
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
