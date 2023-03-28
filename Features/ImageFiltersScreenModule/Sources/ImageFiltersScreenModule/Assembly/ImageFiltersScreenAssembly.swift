//
//  ImageFiltersScreenAssembly.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit

/// Сборщик `ImageFiltersScreen`
public final class ImageFiltersScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `ImageFiltersScreen`
  /// - Parameter permissionService: Сервис по работе с разрешениями
  /// - Returns: Cобранный модуль `ImageFiltersScreen`
  public func createModule(permissionService: ImageFiltersPermissionServiceProtocol) -> ImageFiltersScreenModule {
    let interactor = ImageFiltersScreenInteractor(permissionService: permissionService)
    let view = ImageFiltersScreenView()
    let factory = ImageFiltersScreenFactory()
    let presenter = ImageFiltersScreenViewController(moduleView: view, interactor: interactor, factory: factory)
    
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
