//
//  FortuneWheelEditSectionAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// Сборщик `FortuneWheelEditSection`
final class FortuneWheelEditSectionAssembly {
  
  /// Собирает модуль `FortuneWheelEditSection`
  /// - Returns: Cобранный модуль `FortuneWheelEditSection`
  func createModule() -> FortuneWheelEditSectionModule {
    let interactor = FortuneWheelEditSectionInteractor()
    let view = FortuneWheelEditSectionView()
    let factory = FortuneWheelEditSectionFactory()
    let presenter = FortuneWheelEditSectionViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
