//
//  NumberScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Сборщик `NumberScreen`
public final class NumberScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `NumberScreen`
  /// - Parameters:
  ///  - storageService: Сервис хранения данных
  public func createModule(storageService: NumberScreenStorageServiceProtocol) -> NumberScreenModule {
    let view = NumberScreenView()
    let interactor = NumberScreenInteractor(storageService: storageService)
    let factory = NumberScreenFactory()
    let presenter = NumberScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
