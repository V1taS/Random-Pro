//
//  TeamsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol TeamsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol TeamsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: TeamsScreenCoordinatorOutput? { get set }
}

typealias TeamsScreenCoordinatorProtocol = TeamsScreenCoordinatorInput & Coordinator

final class TeamsScreenCoordinator: TeamsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: TeamsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var teamsScreenModule: TeamsScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listPlayersScreenCoordinator: ListPlayersScreenCoordinatorProtocol?
  private var shareScreenCoordinator: ShareScreenCoordinatorProtocol?
  
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
    let teamsScreenModule = TeamsScreenAssembly().createModule()
    self.teamsScreenModule = teamsScreenModule
    self.teamsScreenModule?.moduleOutput = self
    navigationController.pushViewController(teamsScreenModule, animated: true)
  }
}

// MARK: - TeamsScreenModuleOutput

extension TeamsScreenCoordinator: TeamsScreenModuleOutput {
  func shareButtonAction(imageData: Data?) {
    let shareScreenCoordinator = ShareScreenCoordinator(navigationController,
                                                        services)
    self.shareScreenCoordinator = shareScreenCoordinator
    self.shareScreenCoordinator?.output = self
    shareScreenCoordinator.start()
    
    self.shareScreenCoordinator?.updateContentWith(imageData: imageData)
  }
  
  func cleanButtonWasSelected() {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(
      generatedTeamsCount: "\(teamsScreenModule?.returnGeneratedCountTeams() ?? .zero)",
      allPlayersCount: "\(teamsScreenModule?.returnListPlayers().count ?? .zero)",
      generatedPlayersCount: "\(teamsScreenModule?.returnGeneratedCountPlayers() ?? .zero)"
    ))
  }
  
  func listPlayersIsEmpty() {
    services.notificationService.showNeutralAlertWith(title: Appearance().addPlayersTitle,
                                                      glyph: false,
                                                      active: {})
  }
  
  func settingButtonAction(players: [TeamsScreenPlayerModel]) {
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
    
    guard let teamsScreenModule = teamsScreenModule else {
      return
    }
    listPlayersScreenCoordinator.updateContentWith(models: teamsScreenModule.returnListPlayers(),
                                                   teamsCount: teamsScreenModule.returnSelectedTeam())
  }
  
  func cleanButtonAction() {
    teamsScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListPlayersScreenCoordinatorOutput

extension TeamsScreenCoordinator: ListPlayersScreenCoordinatorOutput {
  func didReceive(players: [TeamsScreenPlayerModel]) {
    guard let teamsScreenModule = teamsScreenModule else {
      return
    }
    
    teamsScreenModule.updateContentWith(players: players)
    settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(
      generatedTeamsCount: "\(teamsScreenModule.returnGeneratedCountTeams())",
      allPlayersCount: "\(players.count)",
      generatedPlayersCount: "\(teamsScreenModule.returnGeneratedCountPlayers())"
    ))
    
    teamsScreenModule.updateContentWith(players: players)
  }
}

// MARK: - ShareScreenCoordinatorOutput

extension TeamsScreenCoordinator: ShareScreenCoordinatorOutput {}

// MARK: - Appearance

private extension TeamsScreenCoordinator {
  struct Appearance {
    let addPlayersTitle = NSLocalizedString("Добавьте игроков", comment: "")
  }
}
