//
//  BottleScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import TimerService
import BottleScreenModule
import HapticService

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol BottleScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol BottleScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: BottleScreenCoordinatorOutput? { get set }
}

typealias BottleScreenCoordinatorProtocol = BottleScreenCoordinatorInput & Coordinator

final class BottleScreenCoordinator: BottleScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: BottleScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var bottleScreenModule: BottleModuleInput?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var bottleScreenModule = BottleScreenAssembly().createModule(
      timerService: TimerServiceImpl(),
      hapticService: HapticServiceImpl(patternType: .feedingCrocodile)
    )
    self.bottleScreenModule = bottleScreenModule
    bottleScreenModule.moduleOutput = self
    navigationController.pushViewController(bottleScreenModule, animated: true)
  }
}

// MARK: - BottleScreenModuleOutput

extension BottleScreenCoordinator: BottleScreenModuleOutput {}

// MARK: - Adapter TimerService

extension TimerServiceImpl: BottleScreenTimerServiceProtocol {}

// MARK: - Adapter HapticService

extension HapticServiceImpl: BottleScreenHapticServiceProtocol {}
