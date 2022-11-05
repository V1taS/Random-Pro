//
//  ListPlayersScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol ListPlayersScreenCoordinatorOutput: AnyObject {
  
  /// Были получены игроки
  ///  - Parameter players: Список игроков
  func didReceive(players: [TeamsScreenPlayerModel])
}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol ListPlayersScreenCoordinatorInput {
  
  /// Обновить контент
  ///  - Parameters:
  ///   - models: Модели игроков
  ///   - teamsCount: Общее количество игроков
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int)
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: ListPlayersScreenCoordinatorOutput? { get set }
}

typealias ListPlayersScreenCoordinatorProtocol = ListPlayersScreenCoordinatorInput & Coordinator

final class ListPlayersScreenCoordinator: ListPlayersScreenCoordinatorProtocol {
  
  // MARK: - Internal property
  
  weak var output: ListPlayersScreenCoordinatorOutput?
  
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
  
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int) {
    listPlayersScreenModule?.updateContentWith(models: models, teamsCount: teamsCount)
  }
}

// MARK: - ListPlayersScreenModuleOutput

extension ListPlayersScreenCoordinator: ListPlayersScreenModuleOutput {
  func removePlayersButtonAction() {
    removePlayersAlert()
  }
  
  func didReceive(players: [TeamsScreenPlayerModel]) {
    output?.didReceive(players: players)
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
