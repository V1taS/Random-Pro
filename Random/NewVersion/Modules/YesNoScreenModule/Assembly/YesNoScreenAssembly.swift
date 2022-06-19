//
//  YesNoScreenAssembly.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 12.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

final class YesNoScreenAssembly {
  
  /// Собирает модуль `YesNoScreen`
  func createModule() -> YesNoScreenModule {
    let view = YesNoScreenView()
    let interactor = YesNoScreenInteractor()
    let factory = YesNoScreenFactory()
    let presenter = YesNoScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
