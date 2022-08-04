//
//  PasswordScreenAssembly.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class PasswordScreenAssembly {
  func createModule() -> PasswordScreenModule {
    let view = PasswordScreenView()
    let interactor = PasswordScreenInteractor()
    let factory = PasswordScreenFactory()
    let presenter = PasswordScreenViewController(moduleView: view,
                                                 interactor: interactor,
                                                 factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
