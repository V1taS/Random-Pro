//
//  SelecteAppIconScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import SelecteAppIconScreenModule
import NotificationService
import StorageService
import YandexMobileMetrica
import FirebaseAnalytics
import MetricsService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol SelecteAppIconScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
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
  private var anyCoordinator: Coordinator?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let selecteAppIconScreenModule = SelecteAppIconScreenAssembly().createModule(storageService: StorageServiceImpl())
    self.selecteAppIconScreenModule = selecteAppIconScreenModule
    self.selecteAppIconScreenModule?.moduleOutput = self
    navigationController.pushViewController(selecteAppIconScreenModule, animated: true)
  }
}

// MARK: - SelecteAppIconScreenModuleOutput

extension SelecteAppIconScreenCoordinator: SelecteAppIconScreenModuleOutput {
  func iconSelectedSuccessfully() {
    notificationService.showPositiveAlertWith(title: Appearance().iconSelectedSuccessfullyTitle,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func somethingWentWrong() {
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrong,
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
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
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController)
    anyCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    track(event: .premiumScreen)
  }
  
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}

// MARK: - Adapter StorageService

extension StorageServiceImpl: SelecteAppIconScreenStorageServiceProtocol {}

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
