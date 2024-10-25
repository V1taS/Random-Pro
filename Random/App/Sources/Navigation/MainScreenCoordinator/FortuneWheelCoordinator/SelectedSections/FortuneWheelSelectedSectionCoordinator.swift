//
//  FortuneWheelSelectedSectionCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol FortuneWheelSelectedSectionCoordinatorOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveNew(model: FortuneWheelModel)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol FortuneWheelSelectedSectionCoordinatorInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter model: Модель данных
  func setDefault(model: FortuneWheelModel)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: FortuneWheelSelectedSectionCoordinatorOutput? { get set }
}

typealias FortuneWheelSelectedSectionCoordinatorProtocol = FortuneWheelSelectedSectionCoordinatorInput & Coordinator

final class FortuneWheelSelectedSectionCoordinator: FortuneWheelSelectedSectionCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: FortuneWheelSelectedSectionCoordinatorOutput?
  var isPushViewController: Bool = false
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var anyNavigationController: UINavigationController?
  private let services: ApplicationServices
  private var fortuneWheelSelectedSectionModule: FortuneWheelSelectedSectionModule?
  
  // Coordinators
  private var fortuneWheelEditSectionCoordinator: FortuneWheelEditSectionCoordinator?
  
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
    var fortuneWheelSelectedSectionModule = FortuneWheelSelectedSectionAssembly().createModule()
    self.fortuneWheelSelectedSectionModule = fortuneWheelSelectedSectionModule
    fortuneWheelSelectedSectionModule.moduleOutput = self
    fortuneWheelSelectedSectionModule.isPushViewController = isPushViewController
    
    if isPushViewController {
      navigationController.pushViewController(fortuneWheelSelectedSectionModule, animated: true)
    } else {
      let anyNavigationController = UINavigationController(rootViewController: fortuneWheelSelectedSectionModule)
      self.anyNavigationController = anyNavigationController
      navigationController.present(anyNavigationController, animated: true)
    }
  }
  
  func setDefault(model: FortuneWheelModel) {
    fortuneWheelSelectedSectionModule?.setDefault(model: model)
  }
}

// MARK: - FortuneWheelSelectedSectionModuleOutput

extension FortuneWheelSelectedSectionCoordinator: FortuneWheelSelectedSectionModuleOutput {
  func moduleClosed() {
    finishFlow?()
  }
  
  func editCurrentSectionWith(section: FortuneWheelModel.Section) {
    guard let model = fortuneWheelSelectedSectionModule?.returnCurrentModel() else {
      return
    }
    
    var navigationController: UINavigationController = navigationController
    if let anyNavigationController {
      navigationController = anyNavigationController
    }
    
    var isLimitedRangeLocation = isPushViewController
    let fortuneWheelEditSectionCoordinator = FortuneWheelEditSectionCoordinator(
      navigationController,
      services
    )
    self.fortuneWheelEditSectionCoordinator = fortuneWheelEditSectionCoordinator
    fortuneWheelEditSectionCoordinator.output = self
    fortuneWheelEditSectionCoordinator.isLimitedRangeLocation = isLimitedRangeLocation
    fortuneWheelEditSectionCoordinator.start()
    fortuneWheelEditSectionCoordinator.finishFlow = { [weak self] in
      self?.fortuneWheelEditSectionCoordinator = nil
    }
    
    fortuneWheelEditSectionCoordinator.editCurrentSectionWith(
      model: model,
      section: section
    )
  }
  
  func createNewSection() {
    guard let model = fortuneWheelSelectedSectionModule?.returnCurrentModel() else {
      return
    }
    
    var isLimitedRangeLocation = isPushViewController
    var navigationController: UINavigationController = navigationController
    if let anyNavigationController {
      navigationController = anyNavigationController
    }
    
    let fortuneWheelEditSectionCoordinator = FortuneWheelEditSectionCoordinator(navigationController, services)
    fortuneWheelEditSectionCoordinator.isLimitedRangeLocation = isLimitedRangeLocation
    self.fortuneWheelEditSectionCoordinator = fortuneWheelEditSectionCoordinator
    fortuneWheelEditSectionCoordinator.output = self
    fortuneWheelEditSectionCoordinator.start()
    
    fortuneWheelEditSectionCoordinator.newSectionWith(model: model)
  }
  
  func didReceiveNew(model: FortuneWheelModel) {
    output?.didReceiveNew(model: model)
  }
  
  func closeButtonAction() {
    anyNavigationController?.dismiss(animated: true)
  }
}

// MARK: - FortuneWheelEditSectionCoordinatorOutput

extension FortuneWheelSelectedSectionCoordinator: FortuneWheelEditSectionCoordinatorOutput {
  func didReceiveEditNew(model: FortuneWheelModel) {
    output?.didReceiveNew(model: model)
    fortuneWheelSelectedSectionModule?.setDefault(model: model)
  }
}

// MARK: - Appearance

private extension FortuneWheelSelectedSectionCoordinator {
  struct Appearance {}
}
