//
//  OnboardingScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// Сборщик `OnboardingScreen`
final class OnboardingScreenAssembly {
  
  /// Собирает модуль `OnboardingScreen`
  /// - Returns: Cобранный модуль `OnboardingScreen`
  func createModule() -> OnboardingScreenModule {
    
    let interactor = OnboardingScreenInteractor()
    let view = OnboardingScreenView()
    let factory = OnboardingScreenFactory()
    
    let presenter = OnboardingScreenViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
