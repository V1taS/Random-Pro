//
//  LetterScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class LetterScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var letterScreenModule: LetterScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private let services: ApplicationServices
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal property
  
  func start() {
    let letterScreenModule = LetterScreenAssembly().createModule()
    self.letterScreenModule = letterScreenModule
    self.letterScreenModule?.moduleOutput = self
    navigationController.pushViewController(letterScreenModule, animated: true)
  }
}

// MARK: - LetterScreenModuleOutput

extension LetterScreenCoordinator: LetterScreenModuleOutput {
  func cleanButtonWasSelected(model: LetterScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .letter(model))
  }
  
  func settingButtonAction(model: LetterScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .letter(model))
  }
  
  func didReciveRangeEnded() {
    services.notificationService.showNeutralAlertWith(
      title: Appearance().lettersRangeEnded,
      glyph: true
    )
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension LetterScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction(_ list: [String]) {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: list)
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    letterScreenModule?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    letterScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension LetterScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension LetterScreenCoordinator {
  struct Appearance {
    let lettersRangeEnded = NSLocalizedString("Диапазон букв закончился", comment: "")
  }
}
