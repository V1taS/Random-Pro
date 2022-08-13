//
//  ListPlayersScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ListPlayersScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var listPlayersScreenModule: ListPlayersScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let listPlayersScreenModule = ListPlayersScreenAssembly().createModule()
    self.listPlayersScreenModule = listPlayersScreenModule
    self.listPlayersScreenModule?.moduleOutput = self
    navigationController.pushViewController(listPlayersScreenModule, animated: true)
  }
}

// MARK: - ListPlayersScreenModuleOutput

extension ListPlayersScreenCoordinator: ListPlayersScreenModuleOutput {}
