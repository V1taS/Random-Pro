//
//  YesNoScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class YesNoScreenAssembly {
  
  /// Собирает модуль `YesNoScreen`
  func createModule(services: ApplicationServices) -> YesNoScreenModule {
    let view = YesNoScreenView()
    let interactor = YesNoScreenInteractor(services: services)
    let factory = YesNoScreenFactory()
    let presenter = YesNoScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
