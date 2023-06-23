//
//  FortuneWheelEditSectionCoordinator.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol FortuneWheelEditSectionCoordinatorOutput: AnyObject {
  
  /// Была полученна новая модель данных
  ///  - Parameter model: Модель данных
  func didReceiveEditNew(model: FortuneWheelModel)
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol FortuneWheelEditSectionCoordinatorInput {
  
  /// Редактируем текущую секцию
  ///  - Parameters:
  ///   - model: Модель данных
  ///   - section: Секция
  func editCurrentSectionWith(model: FortuneWheelModel, section: FortuneWheelModel.Section)
  
  /// Создаем новую секцию
  ///  - Parameters:
  ///   - model: Модель данных
  func newSectionWith(model: FortuneWheelModel)
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: FortuneWheelEditSectionCoordinatorOutput? { get set }
}

typealias FortuneWheelEditSectionCoordinatorProtocol = FortuneWheelEditSectionCoordinatorInput & Coordinator

final class FortuneWheelEditSectionCoordinator: FortuneWheelEditSectionCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: FortuneWheelEditSectionCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var anyNavigationController: UINavigationController?
  private let services: ApplicationServices
  private var fortuneWheelEditSectionModule: FortuneWheelEditSectionModule?
  
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
    var fortuneWheelEditSectionModule = FortuneWheelEditSectionAssembly().createModule(services: services)
    self.fortuneWheelEditSectionModule = fortuneWheelEditSectionModule
    fortuneWheelEditSectionModule.moduleOutput = self
    navigationController.pushViewController(fortuneWheelEditSectionModule, animated: true)
  }
  
  func editCurrentSectionWith(model: FortuneWheelModel, section: FortuneWheelModel.Section) {
    fortuneWheelEditSectionModule?.editCurrentSectionWith(model: model, section: section)
  }
  
  func newSectionWith(model: FortuneWheelModel) {
    fortuneWheelEditSectionModule?.newSectionWith(model: model)
  }
}

// MARK: - FortuneWheelEditSectionModuleOutput

extension FortuneWheelEditSectionCoordinator: FortuneWheelEditSectionModuleOutput {
  func removeTextsButtonAction() {
    removeTextAlert()
  }
  
  func didReceiveNew(model: FortuneWheelModel) {
    output?.didReceiveEditNew(model: model)
  }
}

// MARK: - Private

private extension FortuneWheelEditSectionCoordinator {
  func removeTextAlert() {
    let appearance = Appearance()
    let alert = UIAlertController(title: appearance.removeTextTitle + "?",
                                  message: "",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: appearance.removeTextCancel,
                                  style: .cancel,
                                  handler: { _ in }))
    alert.addAction(UIAlertAction(title: appearance.removeTextYes,
                                  style: .default,
                                  handler: { [weak self] _ in
      self?.fortuneWheelEditSectionModule?.removeAllObjects()
    }))
    fortuneWheelEditSectionModule?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Appearance

private extension FortuneWheelEditSectionCoordinator {
  struct Appearance {
    let removeTextTitle = RandomStrings.Localizable.removeItemsFromList
    let removeTextYes = RandomStrings.Localizable.yes
    let removeTextCancel = RandomStrings.Localizable.cancel
  }
}
