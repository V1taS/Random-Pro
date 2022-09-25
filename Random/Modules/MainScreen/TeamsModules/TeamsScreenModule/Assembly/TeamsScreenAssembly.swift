//
//  TeamsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// Сборщик `TeamsScreen`
final class TeamsScreenAssembly {
  
  /// Собирает модуль `TeamsScreen`
  /// - Returns: Cобранный модуль `TeamsScreen`
  func createModule() -> TeamsScreenModule {
    
    let interactor = TeamsScreenInteractor()
    let view = TeamsScreenView()
    let factory = TeamsScreenFactory()
    let presenter = TeamsScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
