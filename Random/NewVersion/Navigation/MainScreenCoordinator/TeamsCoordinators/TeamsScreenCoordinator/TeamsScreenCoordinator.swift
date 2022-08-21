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
  private var listPlayersScreenCoordinator: ListPlayersScreenCoordinatorProtocol?
  
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
  func settingButtonAction<T: PlayerProtocol>(players: [T]) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    self.settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(
      generatedTeamsCount: "\(teamsScreenModule?.returnGeneratedCountTeams() ?? .zero)",
      allPlayersCount: "\(players.count)",
      generatedPlayersCount: "\(teamsScreenModule?.returnGeneratedCountPlayers() ?? .zero)"
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension TeamsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction() {
    let listPlayersScreenCoordinator = ListPlayersScreenCoordinator(navigationController)
    self.listPlayersScreenCoordinator = listPlayersScreenCoordinator
    self.listPlayersScreenCoordinator?.start()
    self.listPlayersScreenCoordinator?.output = self
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
  func cleanButtonAction() {}
}

// MARK: - ListPlayersScreenCoordinatorOutput

extension TeamsScreenCoordinator: ListPlayersScreenCoordinatorOutput {
  func didRecive<T: PlayerProtocol>(players: [T]) {
    guard let teamsScreenModule = teamsScreenModule else {
      return
    }
    
    teamsScreenModule.updateContentWith(players: players)
    settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(
      generatedTeamsCount: "\(teamsScreenModule.returnGeneratedCountTeams())",
      allPlayersCount: "\(players.count)",
      generatedPlayersCount: "\(teamsScreenModule.returnGeneratedCountPlayers())"
    ))
  }
}
