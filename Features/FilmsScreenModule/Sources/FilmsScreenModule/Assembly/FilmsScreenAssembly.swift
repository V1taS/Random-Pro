//
//  FilmsScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2023.
//

import UIKit

/// Сборщик `FilmsScreen`
public final class FilmsScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `FilmsScreen`
  /// - Parameter storageService: Сервис хранения данных
  /// - Parameter networkService: Сервис работы с сетью
  /// - Returns: Cобранный модуль `FilmsScreen`
  public func createModule(storageService: StorageServiceProtocol,
                           networkService: NetworkServiceProtocol) -> FilmsScreenModule {
    let view = FilmsScreenView()
    let factory = FilmsScreenFactory()
    let interactor = FilmsScreenInteractor(storageService: storageService,
                                           networkService: networkService,
                                           factory: factory)
    let presenter = FilmsScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
