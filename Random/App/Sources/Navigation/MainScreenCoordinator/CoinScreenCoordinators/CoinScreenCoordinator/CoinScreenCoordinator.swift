//
//  CoinScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CoinScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CoinScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CoinScreenCoordinatorOutput? { get set }
}

typealias CoinScreenCoordinatorProtocol = CoinScreenCoordinatorInput & Coordinator

final class CoinScreenCoordinator: CoinScreenCoordinatorProtocol {

  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: CoinScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var coinScreenModule: CoinScreenModule?
  
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
    let coinScreenModule = CoinScreenAssembly().createModule(hapticService: services.hapticService,
                                                             services: services)
    self.coinScreenModule = coinScreenModule
    self.coinScreenModule?.moduleOutput = self
    navigationController.pushViewController(coinScreenModule, animated: true)
  }
}

// MARK: - CoinScreenModuleOutput

extension CoinScreenCoordinator: CoinScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func cleanButtonWasSelected(model: CoinScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .coin(
      isShowlistGenerated: model.isShowlistGenerated,
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: CoinScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .coin(
      isShowlistGenerated: model.isShowlistGenerated,
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

extension CoinScreenCoordinator: SettingsScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    listResultScreenCoordinator.finishFlow = { [weak self] in
      self?.listResultScreenCoordinator = nil
    }
    
    listResultScreenCoordinator.setContentsFrom(list: coinScreenModule?.returnModel()?.listResult ?? [])
  }
  
  func cleanButtonAction() {
    coinScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    coinScreenModule?.listGenerated(isShow: isOn)
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension CoinScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension CoinScreenCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
  }
}
