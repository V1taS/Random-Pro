//
//  CubesScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Сборщик `CubesScreen`
public final class CubesScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `CubesScreen`
  /// - Returns: Cобранный модуль `CubesScreen`
  public func createModule(storageService: CubesScreenStorageServiceProtocol) -> CubesScreenModule {
    let view = CubesScreenView()
    let interactor = CubesScreenInteractor(storageService: storageService)
    let factory = CubesScreenFactory()
    let presenter = CubesScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
