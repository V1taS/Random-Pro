//
//  PasswordScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// Сборщик `PasswordScreen`
public final class PasswordScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `PasswordScreen`
  /// - Returns: Cобранный модуль `PasswordScreen`
  public func createModule(storageService: StorageServiceProtocol) -> PasswordScreenModule {
    let view = PasswordScreenView()
    let interactor = PasswordScreenInteractor(storageService: storageService)
    let factory = PasswordScreenFactory()
    let presenter = PasswordScreenViewController(moduleView: view,
                                                 interactor: interactor,
                                                 factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
