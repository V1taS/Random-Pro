//
//  QuotesScreenAssembly.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit

/// Сборщик `QuotesScreen`
final class QuotesScreenAssembly {
  
  /// Собирает модуль `QuotesScreen`
  /// - Returns: Cобранный модуль `QuotesScreen`
  func createModule() -> QuotesScreenModule {
    let interactor = QuotesScreenInteractor()
    let view = QuotesScreenView()
    let factory = QuotesScreenFactory()
    let presenter = QuotesScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
