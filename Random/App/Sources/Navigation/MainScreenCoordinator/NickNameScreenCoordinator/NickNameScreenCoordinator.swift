//
//  NickNameScreenCoordinator.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol NickNameScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol NickNameScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: NickNameScreenCoordinatorOutput? { get set }
}

typealias NickNameScreenCoordinatorProtocol = NickNameScreenCoordinatorInput & Coordinator

final class NickNameScreenCoordinator: NickNameScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  var finishFlow: (() -> Void)?
  weak var output: NickNameScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var nickNameScreenModule: NickNameScreenModule?
  
  // Coordinators
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
    var nickNameScreenModule = NickNameScreenAssembly().createModule(services: services)
    self.nickNameScreenModule = nickNameScreenModule
    nickNameScreenModule.moduleOutput = self
    navigationController.pushViewController(nickNameScreenModule, animated: true)
  }
}

// MARK: - NickNameScreenModuleOutput

extension NickNameScreenCoordinator: NickNameScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func cleanButtonWasSelected() {
    let model = nickNameScreenModule?.returnCurrentModel()
    settingsScreenCoordinator?.setupDefaultsSettings(for: .nickname(itemsGenerated: "\(model?.listResult.count ?? .zero)",
                                                                    lastItem: model?.result ?? ""))
  }
  
  func settingButtonAction(model: NickNameScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(
      for: .nickname(itemsGenerated: "\(model.listResult.count)",
                     lastItem: model.result)
    )
  }
  
  func resultCopied(text: String) {
    UIPasteboard.general.string = text
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension NickNameScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  func updateStateForSections() {}
  
  func cleanButtonAction() {
    nickNameScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(list: nickNameScreenModule?.returnCurrentModel().listResult ?? [])
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension NickNameScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension NickNameScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
