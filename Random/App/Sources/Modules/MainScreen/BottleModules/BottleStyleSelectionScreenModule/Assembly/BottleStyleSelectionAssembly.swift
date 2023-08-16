//
//  BottleStyleSelectionAssembly.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import Foundation

/// Сборщик `BottleStyleSelection`
public final class BottleStyleSelectionAssembly {

  public init() {}
  
  /// Собирает модуль `BottleStyleSelection`
  /// - Returns: Cобранный модуль `BottleStyleSelection`
  public func createModule() -> BottleStyleSelectionModule {
    let interactor = BottleStyleSelectionInteractor()
    let view = BottleStyleSelectionView()
    let factory = BottleStyleSelectionFactory()
    let presenter = BottleStyleSelectionViewController(
      moduleView: view,
      interactor: interactor,
      factory: factory
    )
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
