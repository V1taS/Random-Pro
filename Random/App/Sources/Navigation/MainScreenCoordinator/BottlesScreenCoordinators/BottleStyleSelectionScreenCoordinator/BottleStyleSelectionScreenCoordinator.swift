//
//  BottleStyleSelectionScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol BottleStyleSelectionScreenCoordinatorOutput: AnyObject {

  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol BottleStyleSelectionScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: BottleStyleSelectionScreenCoordinatorOutput? { get set }
}

/// Псевдоним протокола Coordinator & BottleStyleSelectionScreenCoordinatorInput
typealias BottleStyleSelectionScreenCoordinatorProtocol = Coordinator & BottleStyleSelectionScreenCoordinatorInput

// MARK: - BottleStyleSelectionScreenCoordinator

/// Координатор `BottleStyleSelectionScreen`
final class BottleStyleSelectionScreenCoordinator: BottleStyleSelectionScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: BottleStyleSelectionScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private var bottleStyleSelectionScreenModule: BottleStyleSelectionScreenModule?
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
    let bottleStyleSelectionScreenModule = BottleStyleSelectionScreenAssembly().createModule(services: services)
    self.bottleStyleSelectionScreenModule = bottleStyleSelectionScreenModule
    self.bottleStyleSelectionScreenModule?.moduleOutput = self
    navigationController.pushViewController(bottleStyleSelectionScreenModule, animated: true)
  }
}

// MARK: - BottleStyleSelectionScreenModuleOutput

extension BottleStyleSelectionScreenCoordinator: BottleStyleSelectionScreenModuleOutput {
  func didSelectStyleSuccessfully() {
    services.notificationService.showPositiveAlertWith(title: Appearance().setBottleStyleTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func noPremiumAccessAction() {
    let appearance = Appearance()
    showAlerForUnlockPremiumtWith(title: appearance.premiumAccess,
                                  description: appearance.chooseBottleStyleTitle)
  }

  func moduleClosed() {
    finishFlow?()
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension BottleStyleSelectionScreenCoordinator: PremiumScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension BottleStyleSelectionScreenCoordinator {
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
    bottleStyleSelectionScreenModule?.present(alert, animated: true, completion: nil)
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

private extension BottleStyleSelectionScreenCoordinator {
  struct Appearance {
    let premiumAccess = RandomStrings.Localizable.premiumAccess
    let chooseBottleStyleTitle = RandomStrings.Localizable.changeBottleStyle
    let setBottleStyleTitle = RandomStrings.Localizable.installed
    let cancel = RandomStrings.Localizable.cancel
    let unlock = RandomStrings.Localizable.unlock
  }
}
