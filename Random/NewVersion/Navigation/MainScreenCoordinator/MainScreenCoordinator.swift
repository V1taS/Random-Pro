//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

final class MainScreenCoordinator: Coordinator {
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainScreenModule: MainScreenModule?
  private let services: ApplicationServices
  private var numberScreenCoordinator: Coordinator?
  private var yesNoScreenCoordinator: Coordinator?
  private var dateTimeScreenCoordinator: Coordinator?
  private var letterScreenCoordinator: Coordinator?
  private var coinScreenCoordinator: Coordinator?
  private var lotteryScreenCoordinator: Coordinator?
  private var adminFeatureToggleCoordinator: Coordinator?
  
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
    let mainScreenModule = MainScreenAssembly().createModule()
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    navigationController.pushViewController(mainScreenModule, animated: true)
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func adminFeatureToggleAction() {
    let adminFeatureToggleCoordinator = AdminFeatureToggleCoordinator(navigationController, services)
    self.adminFeatureToggleCoordinator = adminFeatureToggleCoordinator
    adminFeatureToggleCoordinator.start()
  }
  
  func openFilms() {
    // TODO: - Open Coordinator
  }
  
  func openTeams() {
    // TODO: - Open Coordinator
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController)
    self.yesNoScreenCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController, services)
    self.letterScreenCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
  }
  
  func openList() {
    // TODO: - Open Coordinator
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController)
    self.coinScreenCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
  }
  
  func openCube() {
    // TODO: - Open Coordinator
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController, services)
    self.dateTimeScreenCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController, services)
    self.lotteryScreenCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
  }
  
  func openContact() {
    // TODO: - Open Coordinator
  }
  
  func openPassword() {
    // TODO: - Open Coordinator
  }
  
  func openRussianLotto() {
    // TODO: - Open Coordinator
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController, services)
    self.numberScreenCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
  }
}
