//
//  TeamsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol TeamsScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol TeamsScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: TeamsScreenCoordinatorOutput? { get set }
}

typealias TeamsScreenCoordinatorProtocol = TeamsScreenCoordinatorInput & Coordinator

final class TeamsScreenCoordinator: NSObject, TeamsScreenCoordinatorProtocol {
  
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
    let teamsScreenModule = TeamsScreenAssembly().createModule(services: services)
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
                                                      timeout: nil,
                                                      active: {})
  }
  
  func settingButtonAction(players: [TeamsScreenPlayerModel]) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    self.settingsScreenCoordinator?.setupDefaultsSettings(for: .teams(
      generatedTeamsCount: "\(teamsScreenModule?.returnGeneratedCountTeams() ?? .zero)",
      allPlayersCount: "\(players.count)",
      generatedPlayersCount: "\(teamsScreenModule?.returnGeneratedCountPlayers() ?? .zero)"
    ))
  }
  
  func showTeamRenameAlert(name: String, id: String) {
    let appearance = Appearance()
    let alert = UIAlertController(title: appearance.changeTeamName,
                                  message: "",
                                  preferredStyle: .alert)
    alert.addTextField { textField in
      textField.text = name
      textField.delegate = self
    }
    alert.addAction(UIAlertAction(title: appearance.cancel,
                                  style: .cancel,
                                  handler: { _ in }))
    alert.addAction(UIAlertAction(title: appearance.save,
                                  style: .default,
                                  handler: { [weak self] _ in
      if let textField = alert.textFields?.first {
        guard let newName = textField.text else { return }
        if newName.isEmpty {
          alert.dismiss(animated: false)
        } else {
          self?.teamsScreenModule?.renameTeamAlertAction(name: newName, id: id)
        }
      }
    }))
    teamsScreenModule?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension TeamsScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func listOfObjectsAction() {
    let listPlayersScreenCoordinator = ListPlayersScreenCoordinator(navigationController, services)
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

// MARK: - UITextFieldDelegate

extension TeamsScreenCoordinator: UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    if range.location >= 15 {
      return false
    }
    return true
  }
}

// MARK: - Appearance

private extension TeamsScreenCoordinator {
  struct Appearance {
    let addPlayersTitle = RandomStrings.Localizable.addPlayers
    let changeTeamName = RandomStrings.Localizable.changeTeamName
    let save = RandomStrings.Localizable.save
    let cancel = RandomStrings.Localizable.cancel
  }
}
