//
//  CoinScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class CoinScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  private var coinScreenModule: CoinScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let coinScreenModule = CoinScreenAssembly().createModule()
    self.coinScreenModule = coinScreenModule
    self.coinScreenModule?.moduleOutput = self
    navigationController.pushViewController(coinScreenModule, animated: true)
  }
}

// MARK: - CoinScreenModuleOutput

extension CoinScreenCoordinator: CoinScreenModuleOutput {
  func cleanButtonWasSelected(model: CoinScreenModel) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .coin(model))
  }
  
  func settingButtonAction(model: CoinScreenModel) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .coin(model))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension CoinScreenCoordinator: SettingsScreenCoordinatorOutput {
  func listOfObjectsAction(_ list: [String]) {
    let listResultScreenCoordinator = ListResultScreenCoordinator(navigationController)
    self.listResultScreenCoordinator = listResultScreenCoordinator
    self.listResultScreenCoordinator?.output = self
    self.listResultScreenCoordinator?.start()
    
    listResultScreenCoordinator.setContentsFrom(list: list)
  }
  
  func cleanButtonAction() {
    coinScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension CoinScreenCoordinator: ListResultScreenCoordinatorOutput {}
