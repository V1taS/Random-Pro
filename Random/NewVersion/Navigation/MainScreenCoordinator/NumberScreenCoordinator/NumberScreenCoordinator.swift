//
//  NumberScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

final class NumberScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var numberScreenModule: NumberScreenModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
  // MARK: - Initialization
  
  init(navigationController: UINavigationController, services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let numberScreenModule = NumberScreenAssembly().createModule(keyboardService: services.keyboardService)
    self.numberScreenModule = numberScreenModule
    numberScreenModule.moduleOutput = self
    navigationController.pushViewController(numberScreenModule, animated: true)
  }
}

// MARK: - NumberScreenModuleOutput

extension NumberScreenCoordinator: NumberScreenModuleOutput {
  func resultLabelAction(text: String?) {
    UIPasteboard.general.string = text
    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    services.notificationService.showSuccess(
      title: Appearance().copiedToClipboard,
      subtitle: nil,
      bannerPosition: .top)
  }
  
  func didReciveRangeEnded() {
    services.notificationService.showWarning(
      title: Appearance().numberRangeEnded,
      subtitle: nil,
      bannerPosition: .top)
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .number(.init(
      isEnabledWithoutRepetition: model.isEnabledWithoutRepetition,
      numbersGenerated: "\(model.listResult.count)",
      lastNumber: model.result,
      listResult: model.listResult
    )))
  }
  
  func settingButtonAction(model: NumberScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController: navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .number(.init(
      isEnabledWithoutRepetition: model.isEnabledWithoutRepetition,
      numbersGenerated: "\(model.listResult.count)",
      lastNumber: model.result,
      listResult: model.listResult
    )))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension NumberScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction(_ list: [String]) {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setupDefaultsSettings(for: .number(list: list))
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    numberScreenModule?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    numberScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension NumberScreenCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Appearance

private extension NumberScreenCoordinator {
  struct Appearance {
    let numberRangeEnded = NSLocalizedString("Диапазон чисел закончился", comment: "")
    let copiedToClipboard = NSLocalizedString("Скопировано в буфер", comment: "")
  }
}
