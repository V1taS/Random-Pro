//
//  YesNoScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol YesNoScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol YesNoScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: YesNoScreenCoordinatorOutput? { get set }
}

typealias YesNoScreenCoordinatorProtocol = YesNoScreenCoordinatorInput & Coordinator

final class YesNoScreenCoordinator: YesNoScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: YesNoScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var yesNoScreenModule: YesNoScreenModule?
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
    let yesNoScreenModule = YesNoScreenAssembly().createModule()
    self.yesNoScreenModule = yesNoScreenModule
    self.yesNoScreenModule?.moduleOutput = self
    navigationController.pushViewController(yesNoScreenModule, animated: true)
  }
}

// MARK: - YesNoScreenModuleOutput

extension YesNoScreenCoordinator: YesNoScreenModuleOutput {
  func cleanButtonWasSelected(model: YesNoScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .yesOrNo(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: YesNoScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .yesOrNo(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension YesNoScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {}
  
  func listOfObjectsAction() {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController, services)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: yesNoScreenModule?.returnListResult() ?? [])
  }
  
  func cleanButtonAction() {
    yesNoScreenModule?.cleanButtonAction()
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension YesNoScreenCoordinator: ListResultScreenCoordinatorOutput {}
