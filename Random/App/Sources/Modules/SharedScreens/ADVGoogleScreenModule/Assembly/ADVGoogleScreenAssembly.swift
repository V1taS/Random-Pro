//
//  ADVGoogleScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//

import UIKit

/// Сборщик `ADVGoogleScreen`
final class ADVGoogleScreenAssembly {
  
  /// Собирает модуль `ADVGoogleScreen`
  /// - Returns: Cобранный модуль `ADVGoogleScreen`
  func createModule() -> ADVGoogleScreenModule {
    let interactor = ADVGoogleScreenInteractor()
    let view = ADVGoogleScreenView()
    let factory = ADVGoogleScreenFactory()
    let presenter = ADVGoogleScreenViewController(moduleView: view,
                                                  interactor: interactor,
                                                  factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
