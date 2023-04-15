//
//  CustomMainSectionsAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// Сборщик `CustomMainSections`
final class CustomMainSectionsAssembly {
  
  /// Собирает модуль `CustomMainSections`
  /// - Returns: Cобранный модуль `CustomMainSections`
  func createModule() -> CustomMainSectionsModule {
    
    let interactor = CustomMainSectionsInteractor()
    let view = CustomMainSectionsView()
    let factory = CustomMainSectionsFactory()
    let presenter = CustomMainSectionsViewController(moduleView: view,
                                                     interactor: interactor,
                                                     factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
