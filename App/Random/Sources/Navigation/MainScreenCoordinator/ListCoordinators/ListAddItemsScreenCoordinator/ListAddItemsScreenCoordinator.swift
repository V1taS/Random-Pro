//
//  ListAddItemsScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import ListScreenModule

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol ListAddItemsScreenCoordinatorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: Модельки с текстами
  func didReceiveText(models: [ListScreenModel.TextModel])
}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol ListAddItemsScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameter models: Модельки с текстами
  func updateContentWith(models: [ListScreenModel.TextModel])
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
  var output: ListAddItemsScreenCoordinatorOutput? { get set }
}

typealias ListAddItemsScreenCoordinatorProtocol = ListAddItemsScreenCoordinatorInput & Coordinator

final class ListAddItemsScreenCoordinator: ListAddItemsScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListAddItemsScreenCoordinatorOutput?
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var listAddItemsScreenModule: ListAddItemsScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    var listAddItemsScreenModule = ListAddItemsScreenAssembly().createModule()
    self.listAddItemsScreenModule = listAddItemsScreenModule
    listAddItemsScreenModule.moduleOutput = self
    navigationController.pushViewController(listAddItemsScreenModule, animated: true)
  }
  
  func updateContentWith(models: [ListScreenModel.TextModel]) {
    listAddItemsScreenModule?.updateContentWith(models: models)
  }
}

// MARK: - ListAddItemsScreenModuleOutput

extension ListAddItemsScreenCoordinator: ListAddItemsScreenModuleOutput {
  func removeTextsButtonAction() {
    removeTextAlert()
  }
  
  func didReceiveText(models: [ListScreenModel.TextModel]) {
    output?.didReceiveText(models: models)
  }
}

// MARK: - Private

private extension ListAddItemsScreenCoordinator {
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
      self?.listAddItemsScreenModule?.removeAllText()
    }))
    listAddItemsScreenModule?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Appearance

private extension ListAddItemsScreenCoordinator {
  struct Appearance {
    let removeTextTitle = NSLocalizedString("Удалить элементы из списка", comment: "")
    let removeTextYes = NSLocalizedString("Да", comment: "")
    let removeTextCancel = NSLocalizedString("Отмена", comment: "")
  }
}
