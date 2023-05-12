//
//  TeamsScreenAlertCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol TeamsScreenAlertCoordinatorOutput: AnyObject {
  
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol TeamsScreenAlertCoordinatorInput {
  
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: TeamsScreenAlertCoordinatorOutput? { get set }
}

typealias TeamsScreenAlertCoordinatorProtocol = TeamsScreenAlertCoordinatorInput & Coordinator

final class TeamsScreenAlertCoordinator: TeamsScreenAlertCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: TeamsScreenAlertCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var listPlayersScreenModule: TeamsScreenAlertModule?
  
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
    let listPlayersScreenModule = TeamsScreenAlertAssembly().createModule()
    self.listPlayersScreenModule = listPlayersScreenModule
    navigationController.present(listPlayersScreenModule, animated: true)
  }
}
