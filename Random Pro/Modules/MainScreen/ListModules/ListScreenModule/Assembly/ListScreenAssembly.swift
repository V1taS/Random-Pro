//
//  ListScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ListScreenAssembly {
  
  /// Собирает модуль `ListScreen`
  /// - Parameters:
  ///   - services: Сервисы приложения
  func createModule(services: ApplicationServices) -> ListScreenModule {
    let view = ListScreenView()
    let interactor = ListScreenInteractor(services: services)
    let factory = ListScreenFactory()
    let presenter = ListScreenViewController(moduleView: view,
                                             interactor: interactor,
                                             factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
