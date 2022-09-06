//
//  ContactScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ContactScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var contactScreenModule: ContactScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
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
    var contactScreenModule = ContactScreenAssembly().createModule(permissionService: services.permissionService)
    self.contactScreenModule = contactScreenModule
    contactScreenModule.moduleOutput = self
    navigationController.pushViewController(contactScreenModule, animated: true)
  }
}

// MARK: - ContactScreenModuleOutput

extension ContactScreenCoordinator: ContactScreenModuleOutput {
  func cleanButtonWasSelected() {
    let model = contactScreenModule?.returnCurrentModel()
    settingsScreenCoordinator?.setupDefaultsSettings(for: .contact(
      itemsGenerated: "\(model?.listResult.count ?? .zero)",
      lastItem: model?.result ?? ""
    ))
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       active: {})
  }
  
  func didReciveError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: true,
                                                       active: {})
  }
  
  func settingButtonAction() {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .contact(
      itemsGenerated: "\(contactScreenModule?.returnCurrentModel().listResult.count ?? .zero)",
      lastItem: contactScreenModule?.returnCurrentModel().result ?? ""
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension ContactScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  
  func cleanButtonAction() {
    contactScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: contactScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension ContactScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension ContactScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
