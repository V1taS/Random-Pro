//
//  PlayerCardSelectionScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PlayerCardSelectionScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PlayerCardSelectionScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PlayerCardSelectionScreenCoordinatorOutput? { get set }
}

typealias PlayerCardSelectionScreenCoordinatorProtocol = PlayerCardSelectionScreenCoordinatorInput & Coordinator

final class PlayerCardSelectionScreenCoordinator: PlayerCardSelectionScreenCoordinatorProtocol {

  // MARK: - Internal property
  
  var finishFlow: (() -> Void)?
  weak var output: PlayerCardSelectionScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var playerCardSelectionScreenModule: PlayerCardSelectionScreenModule?
  
  // Coordinators
  private var premiumScreenCoordinator: PremiumScreenCoordinator?
  
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
    let playerCardSelectionScreenModule = PlayerCardSelectionScreenAssembly().createModule(services: services)
    self.playerCardSelectionScreenModule = playerCardSelectionScreenModule
    self.playerCardSelectionScreenModule?.moduleOutput = self
    navigationController.pushViewController(playerCardSelectionScreenModule, animated: true)
  }
}

// MARK: - PlayerCardSelectionScreenModuleOutput

extension PlayerCardSelectionScreenCoordinator: PlayerCardSelectionScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func didSelectStyleSuccessfully() {
    services.notificationService.showPositiveAlertWith(title: Appearance().setCardStyleTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func noPremiumAccessAction() {
    let appearance = Appearance()
    showAlerForUnlockPremiumtWith(title: appearance.premiumAccess,
                                  description: appearance.chooseCardStyleTitle)
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension PlayerCardSelectionScreenCoordinator: PremiumScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension PlayerCardSelectionScreenCoordinator {
  func showAlerForUnlockPremiumtWith(title: String, description: String) {
    let appearance = Appearance()
    let alert = UIAlertController(title: title,
                                  message: description,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: appearance.cancel,
                                  style: .cancel,
                                  handler: { _ in }))
    alert.addAction(UIAlertAction(title: appearance.unlock,
                                  style: .default,
                                  handler: { [weak self] _ in
      self?.openPremium()
    }))
    playerCardSelectionScreenModule?.present(alert, animated: true, completion: nil)
  }
  
  func openPremium() {
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController,
                                                            services)
    self.premiumScreenCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    premiumScreenCoordinator.finishFlow = { [weak self] in
      self?.premiumScreenCoordinator = nil
    }
  }
}

// MARK: - Appearance

private extension PlayerCardSelectionScreenCoordinator {
  struct Appearance {
    let premiumAccess = RandomStrings.Localizable.premiumAccess
    let chooseCardStyleTitle = RandomStrings.Localizable.changeCardStyle
    let setCardStyleTitle = RandomStrings.Localizable.installed
    let cancel = RandomStrings.Localizable.cancel
    let unlock = RandomStrings.Localizable.unlock
  }
}
