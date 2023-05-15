//
//  NickNameScreenAssembly.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// Сборщик `NickNameScreen`
final class NickNameScreenAssembly {
  
  /// Собирает модуль `NickNameScreen`
  /// - Returns: Cобранный модуль `NickNameScreen`
  func createModule() -> NickNameScreenModule {
    let interactor = NickNameScreenInteractor()
    let view = NickNameScreenView()
    let factory = NickNameScreenFactory()
    let presenter = NickNameScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
