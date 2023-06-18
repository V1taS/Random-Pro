//
//  FortuneWheelSelectedSectionAssembly.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//

import UIKit

/// Сборщик `FortuneWheelSelectedSection`
final class FortuneWheelSelectedSectionAssembly {
  
  /// Собирает модуль `FortuneWheelSelectedSection`
  /// - Returns: Cобранный модуль `FortuneWheelSelectedSection`
  func createModule() -> FortuneWheelSelectedSectionModule {
    let interactor = FortuneWheelSelectedSectionInteractor()
    let view = FortuneWheelSelectedSectionView()
    let factory = FortuneWheelSelectedSectionFactory()
    let presenter = FortuneWheelSelectedSectionViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
