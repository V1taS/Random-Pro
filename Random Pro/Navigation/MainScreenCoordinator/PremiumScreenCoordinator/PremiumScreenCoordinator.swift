//
//  PremiumScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol PremiumScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol PremiumScreenCoordinatorInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumScreenPresentType)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: PremiumScreenCoordinatorOutput? { get set }
}

typealias PremiumScreenCoordinatorProtocol = PremiumScreenCoordinatorInput & Coordinator

final class PremiumScreenCoordinator: PremiumScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: PremiumScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var premiumScreenModule: PremiumScreenModule?
  private var presentType: PremiumScreenPresentType?
  private var premiumScreenNavigationController: UINavigationController?
  
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
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    presentType = type
  }
  
  func start() {
    guard let presentType else {
      return
    }
    
    let premiumScreenModule = PremiumScreenAssembly().createModule()
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    premiumScreenModule.selectPresentType(presentType)
    
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
  func closeButtonAction() {
    premiumScreenNavigationController?.dismiss(animated: true)
  }
}

// MARK: - Appearance

private extension PremiumScreenCoordinator {
  struct Appearance {}
}
