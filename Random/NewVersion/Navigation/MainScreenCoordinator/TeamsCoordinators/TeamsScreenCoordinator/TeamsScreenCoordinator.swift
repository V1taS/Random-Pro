//
//  TeamsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class TeamsScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var teamsScreenModule: TeamsScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listPlayersScreenCoordinator: Coordinator?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let teamsScreenModule = TeamsScreenAssembly().createModule()
    self.teamsScreenModule = teamsScreenModule
    self.teamsScreenModule?.moduleOutput = self
    navigationController.pushViewController(teamsScreenModule, animated: true)
  }
}

// MARK: - TeamsScreenModuleOutput

extension TeamsScreenCoordinator: TeamsScreenModuleOutput {
  func settingButtonAction(model: TeamsScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    self.settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(model))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension TeamsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func cleanButtonAction() {}
  func listOfObjectsAction(_ list: [String]) {
    let listPlayersScreenCoordinator = ListPlayersScreenCoordinator(navigationController)
    self.listPlayersScreenCoordinator = listPlayersScreenCoordinator
    self.listPlayersScreenCoordinator?.start()
  }
}
