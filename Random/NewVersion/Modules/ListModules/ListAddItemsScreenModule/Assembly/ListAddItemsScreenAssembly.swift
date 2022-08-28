//
//  ListAddItemsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit

/// Сборщик `ListAddItemsScreen`
final class ListAddItemsScreenAssembly {
  
  /// Собирает модуль `ListAddItemsScreen`
  /// - Returns: Cобранный модуль `ListAddItemsScreen`
  func createModule() -> ListAddItemsScreenModule {
    
    let interactor = ListAddItemsScreenInteractor()
    let view = ListAddItemsScreenView()
    let factory = ListAddItemsScreenFactory()
    
    let presenter = ListAddItemsScreenViewController(interactor: interactor,
                                                     moduleView: view,
                                                     factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
