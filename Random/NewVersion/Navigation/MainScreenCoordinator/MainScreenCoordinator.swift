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
  private var anyCoordinator: Coordinator?
  
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
    anyCoordinator = adminFeatureToggleCoordinator
    adminFeatureToggleCoordinator.start()
  }
  
  func openFilms() {
    let moviesScreenCoordinator = MoviesScreenCoordinator(navigationController)
    anyCoordinator = moviesScreenCoordinator
    moviesScreenCoordinator.start()
  }
  
  func openTeams() {
    let teamsScreenCoordinator = TeamsScreenCoordinator(navigationController)
    anyCoordinator = teamsScreenCoordinator
    teamsScreenCoordinator.start()
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController)
    anyCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController, services)
    anyCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
  }
  
  func openList() {
    // TODO: - Open Coordinator
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController)
    anyCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
  }
  
  func openCube() {
   let cubesScreenCoordinator = CubesScreenCoordinator(navigationController)
    anyCoordinator = cubesScreenCoordinator
    cubesScreenCoordinator.start()
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController, services)
    anyCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController, services)
    anyCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
  }
  
  func openContact() {
    // TODO: - Open Coordinator
  }
  
  func openPassword() {
    let passwordScreenCoordinator = PasswordScreenCoordinator(navigationController)
    anyCoordinator = passwordScreenCoordinator
    passwordScreenCoordinator.start()
  }
  
  func openRussianLotto() {
    // TODO: - Open Coordinator
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController, services)
    anyCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
  }
}
