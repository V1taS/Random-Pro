//
//  LotteryScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class LotteryScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `LotteryScreen`
  public func createModule(storageService: LotteryScreenStorageServiceProtocol) -> LotteryScreenModule {
    let view = LotteryScreenView()
    let interactor = LotteryScreenInteractor(storageService: storageService)
    let factory = LotteryScreenFactory()
    let presenter = LotteryScreenViewController(moduleView: view,
                                                interactor: interactor,
                                                factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
