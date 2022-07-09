//
//  LetterScreenAssembly.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class LetterScreenAssembly {
  
  /// Собирает модуль `LetterScreen`
  func createModule() -> LetterScreenModule {
    let view = LetterScreenView()
    let interactor = LetterScreenInteractor()
    let factory = LetterScreenFactory()
    let presenter = LetterScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
