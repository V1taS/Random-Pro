//
//  CoinStyleSelectionScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CoinStyleSelectionScreenCoordinatorOutput: AnyObject {

  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CoinStyleSelectionScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CoinStyleSelectionScreenCoordinatorOutput? { get set }
}

/// Псевдоним протокола Coordinator & CoinStyleSelectionScreenCoordinatorInput
typealias CoinStyleSelectionScreenCoordinatorProtocol = Coordinator & CoinStyleSelectionScreenCoordinatorInput

// MARK: - CoinStyleSelectionScreenCoordinator

/// Координатор `CoinStyleSelectionScreen`
final class CoinStyleSelectionScreenCoordinator: CoinStyleSelectionScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: CoinStyleSelectionScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var module: CoinStyleSelectionScreenModule?
  private var navigationController: UINavigationController
  private let services: ApplicationServices

  // Coordinators
  private var premiumScreenCoordinator: PremiumScreenCoordinator?
  
  // MARK: - Initialisation
  
  /// Ининциализатор
  /// - Parameters:
  ///   - navigationController: Навигейшн контроллер
  ///   - services: Сервисы приложения
  init(_ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Life cycle
  
  func start() {
    let module = CoinStyleSelectionScreenAssembly().createModule(services: services)
    self.module = module
    self.module?.moduleOutput = self
    navigationController.pushViewController(module, animated: true)
  }
}

// MARK: - CoinStyleSelectionScreenModuleOutput

extension CoinStyleSelectionScreenCoordinator: CoinStyleSelectionScreenModuleOutput {
  func noPremiumAccessAction() {
    let appearance = Appearance()
    showAlerForUnlockPremiumtWith(title: appearance.premiumAccess,
                                  description: appearance.chooseCoinStyleTitle)
  }

  func didSelectStyleSuccessfully() {
    services.notificationService.showPositiveAlertWith(title: Appearance().setCoinStyleTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func moduleClosed() {
    finishFlow?()
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension CoinStyleSelectionScreenCoordinator: PremiumScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension CoinStyleSelectionScreenCoordinator {
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
    module?.present(alert, animated: true, completion: nil)
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

private extension CoinStyleSelectionScreenCoordinator {
  struct Appearance {
    let premiumAccess = RandomStrings.Localizable.premiumAccess
    let chooseCoinStyleTitle = RandomStrings.Localizable.changeCoinStyle
    let setCoinStyleTitle = RandomStrings.Localizable.installed 
    let cancel = RandomStrings.Localizable.cancel
    let unlock = RandomStrings.Localizable.unlock
  }
}
