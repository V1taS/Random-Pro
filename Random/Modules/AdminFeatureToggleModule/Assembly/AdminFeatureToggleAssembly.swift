//
//  AdminFeatureToggleAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit

/// Сборщик `AdminFeatureToggle`
final class AdminFeatureToggleAssembly {
  
  /// Собирает модуль `AdminFeatureToggle`
  /// - Returns: Cобранный модуль `AdminFeatureToggle`
  func createModule() -> AdminFeatureToggleModule {
    
    let interactor = AdminFeatureToggleInteractor()
    let view = AdminFeatureToggleView()
    let factory = AdminFeatureToggleFactory()
    
    let presenter = AdminFeatureToggleViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
