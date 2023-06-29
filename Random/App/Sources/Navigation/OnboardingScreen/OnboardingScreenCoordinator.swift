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
//  private var onboardingScreenModule: OnboardingScreenModule?
//  private var onboardingScreenNavigationController: UINavigationController?

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

    guard let pages = services.onboardingService.onboardingPages else {
      return
    }

    let sheetVC = WelcomeSheetController()

    sheetVC.pages = pages
    sheetVC.isModalInPresentation = false
    //output?.applyFirstVisit(false)
    navigationController.present(sheetVC, animated: true)
  }
}

// MARK: - OnboardingScreenModuleOutput

//extension OnboardingScreenCoordinator: OnboardingScreenModuleOutput {
//
//  func applyFirstVisit(_ isFirstVisit: Bool) {
//    output?.applyFirstVisit(isFirstVisit)
//  }
//
//  func somethingWentWrong() {
//    services.notificationService.showNegativeAlertWith(title: Appearance().somethingWentWrongTitle,
//                                                       glyph: false,
//                                                       timeout: nil,
//                                                       active: {})
//  }
//
//  func closeButtonAction() {
//    onboardingScreenNavigationController?.dismiss(animated: true)
//  }
//}

// MARK: - Appearance

private extension OnboardingScreenCoordinator {
  struct Appearance {
    let somethingWentWrongTitle = RandomStrings.Localizable.somethingWentWrong
  }
}
