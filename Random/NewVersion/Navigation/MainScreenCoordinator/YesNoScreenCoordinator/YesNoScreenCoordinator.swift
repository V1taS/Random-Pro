//
//  YesNoScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class YesNoScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var yesNoScreenModule: YesNoScreenModule?
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
    let yesNoScreenModule = YesNoScreenAssembly().createModule()
    self.yesNoScreenModule = yesNoScreenModule
    yesNoScreenModule.moduleOutput = self
    navigationController.pushViewController(yesNoScreenModule, animated: true)
  }
}

// MARK: - YesNoScreenModuleOutput

extension YesNoScreenCoordinator: YesNoScreenModuleOutput {
  func cleanButtonWasSelected(model: YesNoScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .yesOrNo(model))
  }
  
  func settingButtonAction(model: YesNoScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    settingsScreenCoordinator.setupDefaultsSettings(for: .yesOrNo(model))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension YesNoScreenCoordinator: SettingsScreenCoordinatorOutput {
  func withoutRepetitionAction(isOn: Bool) {
    
  }
  
  func cleanButtonAction() {
    yesNoScreenModule?.cleanButtonAction()
  }
  
  func listOfObjectsAction(_ list: [String]) {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: list)
  }
}

// MARK: - ListResultScreenCoordinatorOutput

extension YesNoScreenCoordinator: ListResultScreenCoordinatorOutput {
  
}
