//
//  YesNoScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol YesNoScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol YesNoScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: YesNoScreenCoordinatorOutput? { get set }
}

typealias YesNoScreenCoordinatorProtocol = YesNoScreenCoordinatorInput & Coordinator

final class YesNoScreenCoordinator: YesNoScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: YesNoScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var yesNoScreenModule: YesNoScreenModule?
  
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
    let yesNoScreenModule = YesNoScreenAssembly().createModule(services: services)
    self.yesNoScreenModule = yesNoScreenModule
    self.yesNoScreenModule?.moduleOutput = self
    navigationController.pushViewController(yesNoScreenModule, animated: true)
  }
}

// MARK: - YesNoScreenModuleOutput

extension YesNoScreenCoordinator: YesNoScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func cleanButtonWasSelected(model: YesNoScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .yesOrNo(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: YesNoScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .yesOrNo(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func resultLabelAction(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension YesNoScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(list: yesNoScreenModule?.returnListResult() ?? [])
  }
  
  func cleanButtonAction() {
    yesNoScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension YesNoScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension YesNoScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
