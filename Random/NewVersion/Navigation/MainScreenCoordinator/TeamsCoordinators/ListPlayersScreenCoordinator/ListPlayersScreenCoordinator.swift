//
//  ListPlayersScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ListPlayersScreenCoordinator: Coordinator {
  
  // MARK: - Private property
  
  private let navigationController: UINavigationController
  private var listPlayersScreenModule: ListPlayersScreenModule?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - navigationController: UINavigationController
  init(_ navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let listPlayersScreenModule = ListPlayersScreenAssembly().createModule()
    self.listPlayersScreenModule = listPlayersScreenModule
    self.listPlayersScreenModule?.moduleOutput = self
    navigationController.pushViewController(listPlayersScreenModule, animated: true)
  }
}

// MARK: - ListPlayersScreenModuleOutput

extension ListPlayersScreenCoordinator: ListPlayersScreenModuleOutput {
  func removePlayersButtonAction() {
    removePlayersAlert()
  }
  
  func didRecive<T : PlayerProtocol>(players: [T]) {
    // TODO: -
  }
}

// MARK: - Private

private extension ListPlayersScreenCoordinator {
  func removePlayersAlert() {
    let appearance = Appearance()
    let alert = UIAlertController(title: appearance.removePlayersTitle + "?",
                                  message: "",
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: appearance.removePlayersCancel,
                                  style: .cancel,
                                  handler: { _ in }))
    alert.addAction(UIAlertAction(title: appearance.removePlayersYes,
                                  style: .default,
                                  handler: { [weak self] _ in
      self?.listPlayersScreenModule?.removeAllPlayers()
    }))
    listPlayersScreenModule?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenCoordinator {
  struct Appearance {
    let removePlayersTitle = NSLocalizedString("Удалить добавленных игроков", comment: "")
    let removePlayersYes = NSLocalizedString("Да", comment: "")
    let removePlayersCancel = NSLocalizedString("Отмена", comment: "")
  }
}
