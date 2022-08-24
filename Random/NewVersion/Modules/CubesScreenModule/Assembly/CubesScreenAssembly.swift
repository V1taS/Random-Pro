//
//  CubesScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class CubesScreenAssembly {
  func createModule() -> CubesScreenModule {
    let view = CubesScreenView()
    let interactor = CubesScreenInteractor()
    let factory = CubesScreenFactory()
    let presenter = CubesScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
