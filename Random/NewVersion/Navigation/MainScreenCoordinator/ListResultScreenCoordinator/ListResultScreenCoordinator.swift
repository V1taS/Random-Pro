//
//  ListResultScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit

protocol ListResultScreenCoordinatorOutput: AnyObject { }

protocol ListResultScreenCoordinatorInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter typeObject: Тип отображаемого контента
  func setupDefaultsSettings(for typeObject: ListResultScreenType)
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: ListResultScreenCoordinatorOutput? { get set }
}

typealias ListResultScreenCoordinatorProtocol = ListResultScreenCoordinatorInput & Coordinator

final class ListResultScreenCoordinator: ListResultScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListResultScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var listResultScreenModule: ListResultScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let listResultScreenModule = ListResultScreenAssembly().createModule()
    self.listResultScreenModule = listResultScreenModule
    navigationController.pushViewController(listResultScreenModule, animated: true)
  }
}

// MARK: - SettingsScreenCoordinatorInput

extension ListResultScreenCoordinator {
  func setupDefaultsSettings(for typeObject: ListResultScreenType) {
    listResultScreenModule?.setupDefaultsSettings(for: typeObject)
  }
}
