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
    let premiumScreenModule = PremiumScreenAssembly().createModule()
    self.premiumScreenModule = premiumScreenModule
    self.premiumScreenModule?.moduleOutput = self
    
    if presentType == .present {
      navigationController.present(premiumScreenModule, animated: true)
    } else {
      navigationController.pushViewController(premiumScreenModule, animated: true)
    }
  }
}

// MARK: - PremiumScreenModuleOutput

extension PremiumScreenCoordinator: PremiumScreenModuleOutput {}

// MARK: - Appearance

private extension PremiumScreenCoordinator {
  struct Appearance {}
}
