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
  func openColors() {
    let colorsScreenCoordinator = ColorsScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = colorsScreenCoordinator
    colorsScreenCoordinator.start()
    
    services.metricsService.track(event: .colorsScreen)
  }
  
  func openTeams() {
    let teamsScreenCoordinator = TeamsScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = teamsScreenCoordinator
    teamsScreenCoordinator.start()
    
    services.metricsService.track(event: .teamsScreen)
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
    
    services.metricsService.track(event: .yesOrNotScreen)
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
    
    services.metricsService.track(event: .charactersScreen)
  }
  
  func openList() {
    let listScreenCoordinator = ListScreenCoordinator(navigationController,
                                                      services)
    anyCoordinator = listScreenCoordinator
    listScreenCoordinator.start()
    
    services.metricsService.track(event: .listScreen)
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController,
                                                      services)
    anyCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
    
    services.metricsService.track(event: .coinScreen)
  }
  
  func openCube() {
    let cubesScreenCoordinator = CubesScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = cubesScreenCoordinator
    cubesScreenCoordinator.start()
    
    services.metricsService.track(event: .cubeScreen)
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController,
                                                              services)
    anyCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
    
    services.metricsService.track(event: .dateAndTimeScreen)
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController,
                                                            services)
    anyCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
    
    services.metricsService.track(event: .lotteryScreen)
  }
  
  func openContact() {
    let contactScreenCoordinator = ContactScreenCoordinator(navigationController,
                                                            services)
    anyCoordinator = contactScreenCoordinator
    contactScreenCoordinator.start()
    
    services.metricsService.track(event: .contactScreen)
  }
  
  func openPassword() {
    let passwordScreenCoordinator = PasswordScreenCoordinator(navigationController,
                                                              services)
    anyCoordinator = passwordScreenCoordinator
    passwordScreenCoordinator.start()
    
    services.metricsService.track(event: .passwordScreen)
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
    
    services.metricsService.track(event: .numbersScreen)
  }
  
  func shareButtonAction(_ url: URL) {
    let objectsToShare = [url]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      if let popup = activityVC.popoverPresentationController {
        popup.sourceView = mainScreenModule?.view
        popup.sourceRect = CGRect(x: (mainScreenModule?.view.frame.size.width ?? .zero) / 2,
                                  y: (mainScreenModule?.view.frame.size.height ?? .zero) / 4,
                                  width: .zero,
                                  height: .zero)
      }
    }
    
    mainScreenModule?.present(activityVC, animated: true, completion: nil)
    services.metricsService.track(event: .shareApp)
  }
  
  func adminFeatureToggleAction() {
    let adminFeatureToggleCoordinator = AdminFeatureToggleCoordinator(navigationController,
                                                                      services)
    anyCoordinator = adminFeatureToggleCoordinator
    adminFeatureToggleCoordinator.start()
  }
}
