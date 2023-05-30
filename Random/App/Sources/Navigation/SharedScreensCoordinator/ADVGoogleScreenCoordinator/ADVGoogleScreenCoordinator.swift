//
//  ADVGoogleScreenCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 29.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ADVGoogleScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ADVGoogleScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ADVGoogleScreenCoordinatorOutput? { get set }
}

typealias ADVGoogleScreenCoordinatorProtocol = ADVGoogleScreenCoordinatorInput & Coordinator

final class ADVGoogleScreenCoordinator: ADVGoogleScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ADVGoogleScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var advGoogleScreenModule: ADVGoogleScreenModule?
  private var advGooglecreenNavigationController: UINavigationController?
  
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
    let advGoogleScreenModule = ADVGoogleScreenAssembly().createModule()
    self.advGoogleScreenModule = advGoogleScreenModule
    self.advGoogleScreenModule?.moduleOutput = self
    let advGooglecreenNavigationController = UINavigationController(rootViewController: advGoogleScreenModule)
    self.advGooglecreenNavigationController = advGooglecreenNavigationController
    advGooglecreenNavigationController.modalPresentationStyle = .fullScreen
    navigationController.present(advGooglecreenNavigationController, animated: true)
  }
}

// MARK: - ADVGoogleScreenModuleOutput

extension ADVGoogleScreenCoordinator: ADVGoogleScreenModuleOutput {
  func closeButtonAction() {
    advGooglecreenNavigationController?.dismiss(animated: true)
  }
}

// MARK: - Appearance

private extension ADVGoogleScreenCoordinator {
  struct Appearance {
    let somethingWentWrongTitle = RandomStrings.Localizable.somethingWentWrong
  }
}
