//
//  TeamsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import TeamsScreenModule
import StorageService
import NotificationService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol TeamsScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol TeamsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: TeamsScreenCoordinatorOutput? { get set }
}

typealias TeamsScreenCoordinatorProtocol = TeamsScreenCoordinatorInput & Coordinator

final class TeamsScreenCoordinator: TeamsScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: TeamsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var teamsScreenModule: TeamsScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listPlayersScreenCoordinator: ListPlayersScreenCoordinatorProtocol?
  private var shareScreenCoordinator: ShareScreenCoordinatorProtocol?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let teamsScreenModule = TeamsScreenAssembly().createModule(storageService: StorageServiceImpl())
    self.teamsScreenModule = teamsScreenModule
    self.teamsScreenModule?.moduleOutput = self
    navigationController.pushViewController(teamsScreenModule, animated: true)
  }
}

// MARK: - TeamsScreenModuleOutput

extension TeamsScreenCoordinator: TeamsScreenModuleOutput {
  func shareButtonAction(imageData: Data?) {
    let shareScreenCoordinator = ShareScreenCoordinator(navigationController)
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
    notificationService.showNeutralAlertWith(title: Appearance().addPlayersTitle,
                                             glyph: false,
                                             timeout: nil,
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
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
