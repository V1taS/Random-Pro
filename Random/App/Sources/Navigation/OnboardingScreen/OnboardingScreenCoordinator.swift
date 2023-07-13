//
//  OnboardingScreenCoordinator.swift
//  Random
//
//  Created by Artem Pavlov on 19.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import WelcomeSheet

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol OnboardingScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol OnboardingScreenCoordinatorInput {}

typealias OnboardingScreenCoordinatorProtocol = OnboardingScreenCoordinatorInput & Coordinator

final class OnboardingScreenCoordinator: OnboardingScreenCoordinatorProtocol {

  // MARK: - Private property

  private let navigationController: UINavigationController
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
    services.onboardingService.getOnboardingPagesForPresent(
      network: services.networkService,
      storage: services.storageService,
      completion: { [weak self] welcomePages in
        if !welcomePages.isEmpty {
          self?.createOnboardingVC(with: welcomePages)
        }
      })
  }
}

// MARK: - Appearance

private extension OnboardingScreenCoordinator {
  struct Appearance {}
}

// MARK: - Private func

private extension OnboardingScreenCoordinator {
  func createOnboardingVC(with pages: [WelcomeSheetPage]) {
    let onboardingVC = WelcomeSheetController()
    onboardingVC.pages = pages
    onboardingVC.isModalInPresentation = false
    onboardingVC.onDismiss = { [weak self] in
      guard let self = self else {
        return
      }

      self.services.onboardingService.saveWatchedStatus(to: self.services.storageService, for: pages)
    }
    self.navigationController.present(onboardingVC, animated: true)
  }
}
