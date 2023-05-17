//
//  PasswordScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PasswordScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PasswordScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PasswordScreenCoordinatorOutput? { get set }
}

typealias PasswordScreenCoordinatorProtocol = PasswordScreenCoordinatorInput & Coordinator

final class PasswordScreenCoordinator: PasswordScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: PasswordScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var passwordScreenModule: PasswordScreenModule?
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
    var passwordScreenModule = PasswordScreenAssembly().createModule(services: services)
    self.passwordScreenModule = passwordScreenModule
    passwordScreenModule.moduleOutput = self
    navigationController.pushViewController(passwordScreenModule, animated: true)
  }
}

extension PasswordScreenCoordinator: PasswordScreenModuleOutput {
  func cleanButtonWasSelected() {
    let model = passwordScreenModule?.returnCurrentModel()
    settingsScreenCoordinator?.setupDefaultsSettings(for: .password(itemsGenerated: "\(model?.listResult.count ?? .zero)",
                                                                    lastItem: model?.result ?? ""))
  }
  
  func settingButtonAction(model: PasswordScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .password(itemsGenerated: "\(model.listResult.count)",
                                                                   lastItem: model.result))
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
    services.notificationService.showNegativeAlertWith(title: Appearance().atLeastFourCharactersForPassword,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension PasswordScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
  
  func cleanButtonAction() {
    passwordScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: passwordScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension PasswordScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension PasswordScreenCoordinator {
  struct Appearance {
    let atLeastFourCharactersForPassword = RandomStrings.Localizable.atLeast4CharactersForPassword
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
