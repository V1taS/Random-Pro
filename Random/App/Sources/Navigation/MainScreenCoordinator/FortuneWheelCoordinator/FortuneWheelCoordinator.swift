//
//  FortuneWheelCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol FortuneWheelCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol FortuneWheelCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: FortuneWheelCoordinatorOutput? { get set }
}

typealias FortuneWheelCoordinatorProtocol = FortuneWheelCoordinatorInput & Coordinator

final class FortuneWheelCoordinator: FortuneWheelCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: FortuneWheelCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private let services: ApplicationServices
  private var fortuneWheelModule: FortuneWheelModule?
  private var settingsScreenCoordinator: SettingsScreenCoordinatorProtocol?
  private var listResultScreenCoordinator: ListResultScreenCoordinatorProtocol?
  
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
    var fortuneWheelModule = FortuneWheelAssembly().createModule(services: services)
    self.fortuneWheelModule = fortuneWheelModule
    fortuneWheelModule.moduleOutput = self
    navigationController.pushViewController(fortuneWheelModule, animated: true)
  }
}

// MARK: - FortuneWheelModuleOutput

extension FortuneWheelCoordinator: FortuneWheelModuleOutput {}

// MARK: - SettingsScreenCoordinatorOutput

extension FortuneWheelCoordinator: SettingsScreenCoordinatorOutput {
  func cleanButtonAction() {}
  func listOfObjectsAction() {}
}

// MARK: - ListResultScreenCoordinatorOutput

extension FortuneWheelCoordinator: ListResultScreenCoordinatorOutput {}

// MARK: - Private

private extension FortuneWheelCoordinator {}

// MARK: - Appearance

private extension FortuneWheelCoordinator {
  struct Appearance {
    let copiedToClipboard = RandomStrings.Localizable.copyToClipboard
    let somethingWentWrong = RandomStrings.Localizable.somethingWentWrong
  }
}
