//
//  PremiumScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PremiumScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PremiumScreenCoordinatorInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumScreenCoordinator.PremiumScreenPresentType)
  
  /// Установить распродажу
  func setLifetimeSale(_ value: Bool)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PremiumScreenCoordinatorOutput? { get set }
}

typealias PremiumScreenCoordinatorProtocol = PremiumScreenCoordinatorInput & Coordinator

final class PremiumScreenCoordinator: PremiumScreenCoordinatorProtocol {

  enum PremiumScreenPresentType {
    
    /// Модальный показ
    case present
    
    /// Стандартный в навигейшен стеке
    case push
  }
  
  // MARK: - Internal property
  
  var finishFlow: (() -> Void)?
  weak var output: PremiumScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var premiumScreenModule: PremiumScreenModule?
  private var presentType: PremiumScreenPresentType?
  private var premiumScreenNavigationController: UINavigationController?
  private var isLifetimeSale = false
  
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
  
  func setLifetimeSale(_ value: Bool) {
    isLifetimeSale = value
  }
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    presentType = type
  }
  
  func start() {
    guard let presentType else {
      return
    }
    
    let premiumScreenModule = PremiumScreenAssembly().createModule(services.appPurchasesService,
                                                                   services: services)
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    premiumScreenModule.selectIsModalPresentationStyle(presentType == .present)
    premiumScreenModule.setLifetimeSale(isLifetimeSale)
    
    if presentType == .present {
      let premiumScreenNavigationController = UINavigationController(rootViewController: premiumScreenModule)
      self.premiumScreenNavigationController = premiumScreenNavigationController
      premiumScreenNavigationController.modalPresentationStyle = .fullScreen
      navigationController.present(premiumScreenNavigationController, animated: true)
    } else {
      navigationController.pushViewController(premiumScreenModule, animated: true)
    }
  }
}

// MARK: - PremiumScreenModuleOutput

extension PremiumScreenCoordinator: PremiumScreenModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func didReceiveRestoredSuccess() {
    services.notificationService.showPositiveAlertWith(title: Appearance().purchaseRestoredTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrongTitle,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }

  func didReceivePurchasesMissing() {
    services.notificationService.showNegativeAlertWith(title: Appearance().purchasesMissingTitle,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
  }

  func didReceiveSubscriptionPurchaseSuccess() {
    services.notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func didReceiveOneTimePurchaseSuccess() {
    services.notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
                                                       glyph: true,
                                                       timeout: nil,
                                                       active: {})
  }

  func closeButtonAction() {
    premiumScreenNavigationController?.dismiss(animated: true)
  }

  func updateStateForSections() {
    output?.updateStateForSections()
  }
}

// MARK: - Appearance

private extension PremiumScreenCoordinator {
  struct Appearance {
    let purchaseRestoredTitle = RandomStrings.Localizable.purchaseRestored
    let somethingWentWrongTitle = RandomStrings.Localizable.somethingWentWrong
    let purchasesMissingTitle = RandomStrings.Localizable.noPurchasesFound
    let premiumAccessActivatedTitle = RandomStrings.Localizable.premiumAccessActivated
  }
}
