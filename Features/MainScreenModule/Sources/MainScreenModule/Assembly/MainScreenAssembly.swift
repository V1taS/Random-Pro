//
//  MainScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import ApplicationInterface

/// Сборщик `MainScreen`
public final class MainScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `MainScreen`
  /// - Parameters:
  ///   - featureToggleServices: Сервис фича тогглов
  ///   - storageService: Сервис хранения данных
  ///   - appPurchasesService: Сервис покупок
  /// - Returns: Cобранный модуль `MainScreen`
  public func createModule(featureToggleServices: FeatureToggleServicesProtocol,
                           storageService: StorageServiceProtocol,
                           appPurchasesService: AppPurchasesServiceProtocol) -> MainScreenModule {
    let interactor = MainScreenInteractor(featureToggleServices: featureToggleServices,
                                          storageService: storageService,
                                          appPurchasesService: appPurchasesService)
    let view = MainScreenView()
    let factory = MainScreenFactory()
    let presenter = MainScreenViewController(moduleView: view,
                                             interactor: interactor,
                                             factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
