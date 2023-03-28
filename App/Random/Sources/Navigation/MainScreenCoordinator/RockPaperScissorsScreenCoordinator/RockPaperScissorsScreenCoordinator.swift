//
//  RockPaperScissorsScreenCoordinator.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RockPaperScissorsScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol RockPaperScissorsScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol RockPaperScissorsScreenCoordinatorInput {
  
  /// Стиль интерфейса
  /// - Parameter style: Темный или Светлый режим
  func interface(style: UIUserInterfaceStyle?)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: RockPaperScissorsScreenCoordinatorOutput? { get set }
}

typealias RockPaperScissorsScreenCoordinatorProtocol = RockPaperScissorsScreenCoordinatorInput & Coordinator

final class RockPaperScissorsScreenCoordinator: RockPaperScissorsScreenCoordinatorProtocol {

  // MARK: - Internal variables
  
  weak var output: RockPaperScissorsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var rockPaperScissorsScreenModule: RockPaperScissorsScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var rockPaperScissorsScreenModule = RockPaperScissorsScreenAssembly().createModule()
    self.rockPaperScissorsScreenModule = rockPaperScissorsScreenModule
    rockPaperScissorsScreenModule.moduleOutput = self
    navigationController.pushViewController(rockPaperScissorsScreenModule, animated: true)
  }
  
  func interface(style: UIUserInterfaceStyle?) {
    rockPaperScissorsScreenModule?.interface(style: style)
  }
}

// MARK: - Private

extension RockPaperScissorsScreenCoordinator {}

// MARK: - RockPaperScissorsScreenModuleOutput

extension RockPaperScissorsScreenCoordinator: RockPaperScissorsScreenModuleOutput {}
