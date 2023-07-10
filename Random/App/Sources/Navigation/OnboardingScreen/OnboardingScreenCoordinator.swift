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
protocol OnboardingScreenCoordinatorOutput: AnyObject {

  // подтвердить первых вход в приложение
  func applyFirstVisit(_ isFirstVisit: Bool)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol OnboardingScreenCoordinatorInput {

  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: OnboardingScreenCoordinatorOutput? { get set }
}

typealias OnboardingScreenCoordinatorProtocol = OnboardingScreenCoordinatorInput & Coordinator

final class OnboardingScreenCoordinator: OnboardingScreenCoordinatorProtocol {

  // MARK: - Internal property

  weak var output: OnboardingScreenCoordinatorOutput?

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
    services.onboardingService.getContent(
      networkService: services.networkService,
      storageService: services.storageService,
      completion: { [weak self] welcomePages in
        if !welcomePages.isEmpty {
          self?.createOnboardingVC(with: welcomePages)
        }
      })
  }

  private func createOnboardingVC(with pages: [WelcomeSheetPage]) {
    let sheetVC = WelcomeSheetController()
    sheetVC.pages = pages
   sheetVC.onDismiss = { self.services.onboardingService.addWatchedStatusForModels(pages, storageService: self.services.storageService)}
    sheetVC.isModalInPresentation = false
    self.navigationController.present(sheetVC, animated: true)
  }
}

// MARK: - Appearance

private extension OnboardingScreenCoordinator {
  struct Appearance {
    let somethingWentWrongTitle = RandomStrings.Localizable.somethingWentWrong
  }
}
