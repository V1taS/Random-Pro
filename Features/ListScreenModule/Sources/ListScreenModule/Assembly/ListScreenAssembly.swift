//
//  ListScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class ListScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `ListScreen`
  /// - Parameters:
  ///   - storageService: Сервис хранения данных
  public func createModule(storageService: ListScreenStorageServiceProtocol) -> ListScreenModule {
    let view = ListScreenView()
    let interactor = ListScreenInteractor(storageService: storageService)
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
