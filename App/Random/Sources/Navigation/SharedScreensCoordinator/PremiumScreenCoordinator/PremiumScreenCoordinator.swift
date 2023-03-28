//
//  PremiumScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import PremiumScreenModule
import NotificationService
import AppPurchasesService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PremiumScreenCoordinatorOutput: AnyObject {
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PremiumScreenCoordinatorInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumScreenCoordinator.PremiumScreenPresentType)
  
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
  
  weak var output: PremiumScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var premiumScreenModule: PremiumScreenModule?
  private var presentType: PremiumScreenPresentType?
  private var premiumScreenNavigationController: UINavigationController?
  private let notificationService = NotificationServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    presentType = type
  }
  
  func start() {
    guard let presentType else {
      return
    }
    
    let premiumScreenModule = PremiumScreenAssembly().createModule(appPurchasesService: AppPurchasesServiceImpl())
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    premiumScreenModule.selectIsModalPresentationStyle(presentType == .present)
    
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
  func updateMainScreenWith(isPremium: Bool) {
    output?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func didReceiveRestoredSuccess() {
    notificationService.showPositiveAlertWith(title: Appearance().purchaseRestoredTitle,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func somethingWentWrong() {
    notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrongTitle,
                                              glyph: false,
                                              timeout: nil,
                                              active: {})
  }
  
  func didReceivePurchasesMissing() {
    notificationService.showNegativeAlertWith(title: Appearance().purchasesMissingTitle,
                                              glyph: false,
                                              timeout: nil,
                                              active: {})
  }
  
  func didReceiveSubscriptionPurchaseSuccess() {
    notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
                                              glyph: true,
                                              timeout: nil,
                                              active: {})
  }
  
  func didReceiveOneTimePurchaseSuccess() {
    notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
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

// MARK: - Adapter ApphudProductModel

extension ApphudProductModel: PremiumScreenApphudProductProtocol {}

// MARK: - Adapter AppPurchasesServiceState

extension AppPurchasesServiceState: PremiumScreenAppPurchasesServiceStateProtocol {}

// MARK: - Adapter AppPurchasesService

extension AppPurchasesServiceImpl: PremiumScreenAppPurchasesServiceProtocol {
  public func getProductsForPremium(completion: @escaping ([PremiumScreenApphudProductProtocol]?) -> Void) {
    getProducts(completion: completion)
  }
  
  public func purchaseWithForPremium(_ product: PremiumScreenApphudProductProtocol,
                                     completion: @escaping (PremiumScreenAppPurchasesServiceStateProtocol) -> Void) {
    guard let product = product as? ApphudProductModel else {
      return
    }
    purchaseWith(product, completion: completion)
  }
}

// MARK: - Appearance

private extension PremiumScreenCoordinator {
  struct Appearance {
    let purchaseRestoredTitle = NSLocalizedString("Покупка восстановлена", comment: "")
    let somethingWentWrongTitle = NSLocalizedString("Что-то пошло не так", comment: "")
    let purchasesMissingTitle = NSLocalizedString("Покупки отсутствуют", comment: "")
    let premiumAccessActivatedTitle = NSLocalizedString("Премиум доступ активирован", comment: "")
  }
}
