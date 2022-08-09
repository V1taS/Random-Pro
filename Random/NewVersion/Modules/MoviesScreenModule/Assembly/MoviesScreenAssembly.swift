//
//  MoviesScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class MoviesScreenAssembly {
  func createModule() -> MoviesScreenModule {
    let view = MoviesScreenView()
    let interactor = MoviesScreenInteractor()
    let factory = MoviesScreenFactory()
    let presenter = MoviesScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
