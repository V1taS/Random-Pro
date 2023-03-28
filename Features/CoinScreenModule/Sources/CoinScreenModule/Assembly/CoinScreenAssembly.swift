//
//  CoinScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class CoinScreenAssembly {
  
  public init() {}
  
  /// Создает  модуль `CoinScreen`
  /// - Parameters:
  ///  - hapticService: Обратная связь от моторчика
  ///  - storageService: Хранения данных
  public func createModule(hapticService: CoinScreenHapticServiceProtocol,
                           storageService: CoinScreenStorageServiceProtocol) -> CoinScreenModule {
    let view = CoinScreenView()
    let interactor = CoinScreenInteractor(hapticService: hapticService,
                                          storageService: storageService)
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
