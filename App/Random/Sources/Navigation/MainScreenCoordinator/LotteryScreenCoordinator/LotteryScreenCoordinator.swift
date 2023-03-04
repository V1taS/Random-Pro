//
//  LotteryScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import LotteryScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol LotteryScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

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
    let lotteryScreenModule = LotteryScreenAssembly().createModule(storageService: services.storageService)
    self.lotteryScreenModule = lotteryScreenModule
    self.lotteryScreenModule?.moduleOutput = self
    navigationController.pushViewController(lotteryScreenModule, animated: true)
  }
}

// MARK: - LotteryScreenModuleOutput

extension LotteryScreenCoordinator: LotteryScreenModuleOutput {
  func resultLabelAction(model: LotteryScreenModelProtocol) {
    UIPasteboard.general.string = model.result
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    services.notificationService.showPositiveAlertWith(title: Appearance().copiedToClipboard,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func cleanButtonWasSelected(model: LotteryScreenModelProtocol) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .lottery(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: LotteryScreenModelProtocol) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    output?.updateStateForSections()
  }
  
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
