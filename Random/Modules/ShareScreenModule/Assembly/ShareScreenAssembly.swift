//
//  ShareScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// Сборщик `ShareScreen`
final class ShareScreenAssembly {
  
  /// Собирает модуль `ShareScreen`
  /// - Returns: Cобранный модуль `ShareScreen`
  func createModule() -> ShareScreenModule {
    
    let interactor = ShareScreenInteractor()
    let view = ShareScreenView()
    let factory = ShareScreenFactory()
    
    let presenter = ShareScreenViewController(interactor: interactor, moduleView: view, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
