//
//  NickNameScreenCoordinator.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol NickNameScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol NickNameScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: NickNameScreenCoordinatorOutput? { get set }
}

typealias NickNameScreenCoordinatorProtocol = NickNameScreenCoordinatorInput & Coordinator

final class NickNameScreenCoordinator: NickNameScreenCoordinatorProtocol {
  
  weak var output: NickNameScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var nickNameScreenModule: NickNameScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    var nickNameScreenModule = NickNameScreenAssembly().createModule()
    
    self.nickNameScreenModule = nickNameScreenModule
    nickNameScreenModule.moduleOutput = self
    navigationController.pushViewController(nickNameScreenModule, animated: true)
  }
}

// MARK: - NickNameScreenModuleOutput

extension NickNameScreenCoordinator: NickNameScreenModuleOutput {}
