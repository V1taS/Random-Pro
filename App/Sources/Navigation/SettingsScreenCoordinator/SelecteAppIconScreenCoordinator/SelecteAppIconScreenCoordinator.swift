//
//  SelecteAppIconScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol SelecteAppIconScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol SelecteAppIconScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: SelecteAppIconScreenCoordinatorOutput? { get set }
}

typealias SelecteAppIconScreenCoordinatorProtocol = SelecteAppIconScreenCoordinatorInput & Coordinator

final class SelecteAppIconScreenCoordinator: SelecteAppIconScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: SelecteAppIconScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var selecteAppIconScreenModule: SelecteAppIconScreenModule?
  private let services: ApplicationServices
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
    let selecteAppIconScreenModule = SelecteAppIconScreenAssembly().createModule(services: services)
    self.selecteAppIconScreenModule = selecteAppIconScreenModule
    self.selecteAppIconScreenModule?.moduleOutput = self
    navigationController.pushViewController(selecteAppIconScreenModule, animated: true)
  }
}

// MARK: - SelecteAppIconScreenModuleOutput

extension SelecteAppIconScreenCoordinator: SelecteAppIconScreenModuleOutput {
  func iconSelectedSuccessfully() {
    services.notificationService.showPositiveAlertWith(title: Appearance().iconSelectedSuccessfullyTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }
  
  func noPremiumAccessAction() {
    let appearance = Appearance()
    showAlerForUnlockPremiumtWith(title: appearance.premiumAccess,
                                  description: appearance.chooseIconForAppTitle)
  }
}

// MARK: - PremiumScreenCoordinatorOutput

extension SelecteAppIconScreenCoordinator: PremiumScreenCoordinatorOutput {
  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Private

private extension SelecteAppIconScreenCoordinator {
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
    selecteAppIconScreenModule?.present(alert, animated: true, completion: nil)
  }
  
  func openPremium() {
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController,
                                                            services)
    anyCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    
    services.metricsService.track(event: .premiumScreen)
  }
}

// MARK: - Appearance

private extension SelecteAppIconScreenCoordinator {
  struct Appearance {
    let somethingWentWrong = NSLocalizedString("Что-то пошло не так", comment: "")
    let cancel = NSLocalizedString("Отмена", comment: "")
    let unlock = NSLocalizedString("Разблокировать", comment: "")
    let premiumAccess = NSLocalizedString("Премиум доступ", comment: "")
    let chooseIconForAppTitle = NSLocalizedString("Можно изменить цвет иконки приложения", comment: "")
    let iconSelectedSuccessfullyTitle = NSLocalizedString("Цвет иконки установлен", comment: "")
  }
}
