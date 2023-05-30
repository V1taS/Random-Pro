//
//  ContactScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ContactScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ContactScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ContactScreenCoordinatorOutput? { get set }
}

typealias ContactScreenCoordinatorProtocol = ContactScreenCoordinatorInput & Coordinator

final class ContactScreenCoordinator: ContactScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: ContactScreenCoordinatorOutput?
  
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
    var contactScreenModule = ContactScreenAssembly().createModule(services: services)
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
                                                       timeout: nil,
                                                       active: {})
  }
  
  func didReceiveError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func settingButtonAction() {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
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
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
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
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
