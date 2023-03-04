//
//  CoinScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import CoinScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CoinScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CoinScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CoinScreenCoordinatorOutput? { get set }
}

typealias CoinScreenCoordinatorProtocol = CoinScreenCoordinatorInput & Coordinator

final class CoinScreenCoordinator: CoinScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: CoinScreenCoordinatorOutput?
  
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
    let coinScreenModule = CoinScreenAssembly().createModule(hapticService: services.hapticService,
                                                             storageService: services.storageService)
    self.coinScreenModule = coinScreenModule
    self.coinScreenModule?.moduleOutput = self
    navigationController.pushViewController(coinScreenModule, animated: true)
  }
}

// MARK: - CoinScreenModuleOutput

extension CoinScreenCoordinator: CoinScreenModuleOutput {
  func cleanButtonWasSelected(model: CoinScreenModelProtocol) {
    settingsScreenCoordinator?.setupDefaultsSettings(for: .coin(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
  
  func settingButtonAction(model: CoinScreenModelProtocol) {
    let settingsScreenCoordinator = SettingsScreenCoordinator(navigationController, services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    self.settingsScreenCoordinator?.start()
    
    settingsScreenCoordinator.setupDefaultsSettings(for: .coin(
      itemsGenerated: "\(model.listResult.count)",
      lastItem: model.result
    ))
  }
}

// MARK: - SettingsScreenCoordinatorOutput

extension CoinScreenCoordinator: SettingsScreenCoordinatorOutput {
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
    
    listResultScreenCoordinator.setContentsFrom(list: coinScreenModule?.returnListResult() ?? [])
  }
  
  func cleanButtonAction() {
    coinScreenModule?.cleanButtonAction()
  }
  
  func withoutRepetitionAction(isOn: Bool) {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension CoinScreenCoordinator: ListResultScreenCoordinatorOutput {}
