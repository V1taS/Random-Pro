//
//  PlayerCardSelectionScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import TeamsScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PlayerCardSelectionScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PlayerCardSelectionScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PlayerCardSelectionScreenCoordinatorOutput? { get set }
}

typealias PlayerCardSelectionScreenCoordinatorProtocol = PlayerCardSelectionScreenCoordinatorInput & Coordinator

final class PlayerCardSelectionScreenCoordinator: PlayerCardSelectionScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: PlayerCardSelectionScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var playerCardSelectionScreenModule: PlayerCardSelectionScreenModule?
  private var anyCoordinator: Coordinator?
  
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
    let playerCardSelectionScreenModule = PlayerCardSelectionScreenAssembly().createModule(storageService: services.storageService)
    self.playerCardSelectionScreenModule = playerCardSelectionScreenModule
    self.playerCardSelectionScreenModule?.moduleOutput = self
    navigationController.pushViewController(playerCardSelectionScreenModule, animated: true)
  }
}

// MARK: - PlayerCardSelectionScreenModuleOutput

extension PlayerCardSelectionScreenCoordinator: PlayerCardSelectionScreenModuleOutput {
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
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
    anyCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    
    // TODO: - 🔴
//    services.metricsService.track(event: .premiumScreen)
  }
}

// MARK: - Appearance

private extension PlayerCardSelectionScreenCoordinator {
  struct Appearance {
    let premiumAccess = NSLocalizedString("Премиум доступ", comment: "")
    let chooseCardStyleTitle = NSLocalizedString("Можно изменить стиль карточки", comment: "")
    let setCardStyleTitle = NSLocalizedString("Установлено", comment: "")
    let cancel = NSLocalizedString("Отмена", comment: "")
    let unlock = NSLocalizedString("Разблокировать", comment: "")
  }
}