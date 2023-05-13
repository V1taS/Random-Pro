//
//  TeamsScreenAlertAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//

import UIKit

/// Сборщик `TeamsScreenAlert`
final class TeamsScreenAlertAssembly {
  
  /// Собирает модуль `TeamsScreenAlert`
  /// - Returns: Cобранный модуль `TeamsScreenAlert`
  func createModule() -> TeamsScreenAlertModule {
    let interactor = TeamsScreenAlertInteractor()
    let view = TeamsScreenAlertView()
    let factory = TeamsScreenAlertFactory()
    let presenter = TeamsScreenAlertViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
