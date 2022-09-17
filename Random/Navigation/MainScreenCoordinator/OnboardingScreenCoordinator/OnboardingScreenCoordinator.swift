//
//  OnboardingScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol OnboardingScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol OnboardingScreenCoordinatorInput {
  
  /// Вернуть текущую модель
  func returnCurrentModels() -> [OnboardingScreenModel]
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: OnboardingScreenCoordinatorOutput? { get set }
}

typealias OnboardingScreenCoordinatorProtocol = OnboardingScreenCoordinatorInput & Coordinator

final class OnboardingScreenCoordinator: OnboardingScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: OnboardingScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var onboardingScreenModule: OnboardingScreenModule?
  private let services: ApplicationServices
  
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
    let onboardingScreenModule = OnboardingScreenAssembly().createModule()
    self.onboardingScreenModule = onboardingScreenModule
    self.onboardingScreenModule?.moduleOutput = self
    onboardingScreenModule.modalPresentationStyle = .fullScreen
    navigationController.present(onboardingScreenModule, animated: true)
  }
  
  func returnCurrentModels() -> [OnboardingScreenModel] {
    guard let onboardingScreenModule = onboardingScreenModule else {
      return []
    }
    return onboardingScreenModule.returnCurrentModels()
  }
}

// MARK: - OnboardingScreenModuleOutput

extension OnboardingScreenCoordinator: OnboardingScreenModuleOutput {
  func onboardingDidFinish() {
    navigationController.dismiss(animated: true)
  }
}

// MARK: - Appearance

private extension OnboardingScreenCoordinator {
  struct Appearance {}
}
