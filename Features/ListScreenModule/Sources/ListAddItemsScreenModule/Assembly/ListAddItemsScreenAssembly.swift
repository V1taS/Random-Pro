//
//  ListAddItemsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit

/// Сборщик `ListAddItemsScreen`
public final class ListAddItemsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `ListAddItemsScreen`
  /// - Returns: Cобранный модуль `ListAddItemsScreen`
  public func createModule() -> ListAddItemsScreenModule {
    
    let interactor = ListAddItemsScreenInteractor()
    let view = ListAddItemsScreenView()
    let factory = ListAddItemsScreenFactory()
    
    let presenter = ListAddItemsScreenViewController(moduleView: view,
                                                     interactor: interactor,
                                                     factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
