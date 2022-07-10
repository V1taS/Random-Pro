//
//  DateTimeScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class DateTimeScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var dateTimeScreenModule: DateTimeModule?
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
  
  // MARK: - Internal func
  
  func start() {
    let dateTimeScreenModule = DateTimeAssembly().createModule()
    self.dateTimeScreenModule = dateTimeScreenModule
    dateTimeScreenModule.moduleOutput = self
    navigationController.pushViewController(dateTimeScreenModule, animated: true)
  }
}

// MARK: - DateTimeModuleOutput

extension DateTimeScreenCoordinator: DateTimeModuleOutput {
  func resultLabelAction(model: DateTimeScreenModel) {
    UIPasteboard.general.string = model.result
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true)
  }
  
  func cleanButtonWasSelected(model: DateTimeScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .dateAndTime(model))
  }
  
  func settingButtonAction(model: DateTimeScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .dateAndTime(model))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension DateTimeScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction(_ list: [String]) {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: list)
  }
  
  func cleanButtonAction() {
    dateTimeScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension DateTimeScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension DateTimeScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
