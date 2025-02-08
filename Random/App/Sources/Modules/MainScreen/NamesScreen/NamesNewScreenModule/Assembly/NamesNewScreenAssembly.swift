//
//  NamesNewScreenAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import SwiftUI
import SKUIKit

/// Сборщик `NamesNewScreen`
public final class NamesNewScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `NamesNewScreen`
  /// - Returns: Cобранный модуль `NamesNewScreen`
  public func createModule() -> NamesNewScreenModule {
    let interactor = NamesNewScreenInteractor()
    let factory = NamesNewScreenFactory()
    let presenter = NamesNewScreenPresenter(
      interactor: interactor,
      factory: factory
    )
    let view = NamesNewScreenView(presenter: presenter)
    let viewController = SceneViewController(viewModel: presenter, content: view)
    
    interactor.output = presenter
    factory.output = presenter
    return (viewController: viewController, input: presenter)
  }
}
