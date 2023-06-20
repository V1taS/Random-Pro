//
//  OnboardingScreenAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//

import UIKit

/// Сборщик `OnboardingScreen`
final class OnboardingScreenAssembly {
  
  /// Собирает модуль `OnboardingScreen`
  /// - Returns: Cобранный модуль `OnboardingScreen`
  func createModule(services: ApplicationServices) -> OnboardingScreenModule {
    let interactor = OnboardingScreenInteractor(services: services)
    let view = OnboardingScreenView()
    let factory = OnboardingScreenFactory()
    let presenter = OnboardingScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
