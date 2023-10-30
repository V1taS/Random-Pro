//
//  CubesStyleSelectionScreenCoordinator.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol CubesStyleSelectionScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol CubesStyleSelectionScreenCoordinatorInput {

  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: CubesStyleSelectionScreenCoordinatorOutput? { get set }
}

/// Псевдоним протокола Coordinator & BottleStyleSelectionScreenCoordinatorInput
typealias CubesStyleSelectionScreenCoordinatorProtocol = Coordinator & CubesStyleSelectionScreenCoordinatorInput

// MARK: - BottleStyleSelectionScreenCoordinator

/// Координатор `BottleStyleSelectionScreen`
final class CubesStyleSelectionScreenCoordinator: CubesStyleSelectionScreenCoordinatorProtocol {

  // MARK: - Internal variables

  var finishFlow: (() -> Void)?
  weak var output: CubesStyleSelectionScreenCoordinatorOutput?

  // MARK: - Private property

  private var cubesStyleSelectionScreenModule: CubesStyleSelectionScreenModule?
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
    let cubesStyleSelectionScreenModule = CubesStyleSelectionScreenAssembly().createModule(services: services)
    self.cubesStyleSelectionScreenModule = cubesStyleSelectionScreenModule
    self.cubesStyleSelectionScreenModule?.moduleOutput = self
    navigationController.pushViewController(cubesStyleSelectionScreenModule, animated: true)
  }
}

// MARK: - CubesStyleSelectionScreenModuleOutput

extension CubesStyleSelectionScreenCoordinator: CubesStyleSelectionScreenModuleOutput {
  func didSelectStyleSuccessfully() {
    services.notificationService.showPositiveAlertWith(title: Appearance().setCubesStyleTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func noPremiumAccessAction() {
    let appearance = Appearance()
    showAlerForUnlockPremiumtWith(title: appearance.premiumAccess,
                                  description: appearance.chooseCubesStyleTitle)
  }

  func moduleClosed() {
    finishFlow?()
  }
}

// MARK: - Private

private extension CubesStyleSelectionScreenCoordinator {
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
    cubesStyleSelectionScreenModule?.present(alert, animated: true, completion: nil)
  }

  func openPremium() {
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController,
                                                            services)
    self.premiumScreenCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    premiumScreenCoordinator.finishFlow = { [weak self] in
      self?.premiumScreenCoordinator = nil
    }

    services.metricsService.track(event: .premiumScreen)
  }
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenCoordinator {
  struct Appearance {
    let premiumAccess = RandomStrings.Localizable.premiumAccess
    let chooseCubesStyleTitle = RandomStrings.Localizable.changeCubesStyle
    let setCubesStyleTitle = RandomStrings.Localizable.installed
    let cancel = RandomStrings.Localizable.cancel
    let unlock = RandomStrings.Localizable.unlock
  }
}
