//
//  ListResultScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

/// Сборщик `ListResultScreen`
final class ListResultScreenAssembly {
  
  /// Собирает модуль `ListResultScreen`
  /// - Returns: Cобранный модуль `ListResultScreen`
  func createModule() -> ListResultScreenModule {
    
    let interactor = ListResultScreenInteractor()
    let view = ListResultScreenView()
    let factory = ListResultScreenFactory()
    
    let presenter = ListResultScreenViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
