//
//  LotteryScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol LotteryScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol LotteryScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: LotteryScreenCoordinatorOutput? { get set }
}

typealias LotteryScreenCoordinatorProtocol = LotteryScreenCoordinatorInput & Coordinator

final class LotteryScreenCoordinator: LotteryScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: LotteryScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var lotteryScreenModule: LotteryScreenModule?
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
    let lotteryScreenModule = LotteryScreenAssembly().createModule()
    self.lotteryScreenModule = lotteryScreenModule
    self.lotteryScreenModule?.moduleOutput = self
    navigationController.pushViewController(lotteryScreenModule, animated: true)
  }
}

// MARK: - LotteryScreenModuleOutput

extension LotteryScreenCoordinator: LotteryScreenModuleOutput {
  func resultLabelAction(model: LotteryScreenModel) {
    UIPasteboard.general.string = model.result
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func cleanButtonWasSelected(model: LotteryScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .lottery(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: LotteryScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .lottery(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func didReceiveRangeError() {
    services.notificationService.showNegativeAlertWith(title: Appearance().numberRangeError,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension LotteryScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: lotteryScreenModule?.returnListResult() ?? [])
  }
  
  func cleanButtonAction() {
    lotteryScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension LotteryScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension LotteryScreenCoordinator {
  struct Appearance {
    let numberRangeError = NSLocalizedString("Неверно задан диапазон", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
