//
//  PasswordScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import PasswordScreenModule
import NotificationService
import StorageService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PasswordScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
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
  private var passwordScreenModule: PasswordScreenModule?
  private let notificationService = NotificationServiceImpl()
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var passwordScreenModule = PasswordScreenAssembly().createModule(storageService: StorageServiceImpl())
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
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .password(itemsGenerated: "\(model.listResult.count)",
                                                                   lastItem: model.result))
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func didReceiveError() {
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension PasswordScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
  
  func cleanButtonAction() {
    passwordScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: passwordScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension PasswordScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Adapter StorageService

extension StorageServiceImpl: PasswordScreenStorageServiceProtocol {}

// MARK: - Appearance

private extension PasswordScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
