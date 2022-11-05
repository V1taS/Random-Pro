//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// События которые отправляем из `текущего координатора` в  `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в  `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// События которые отправляем из `текущего координатора` в  `другой координатор`
  var output: MainScreenCoordinatorOutput? { get set }
}

typealias MainScreenCoordinatorProtocol = MainScreenCoordinatorInput & Coordinator

final class MainScreenCoordinator: MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainScreenModule: MainScreenModule?
  private let services: ApplicationServices
  private var anyCoordinator: Coordinator?
  private var settingsScreenCoordinator: MainSettingsScreenCoordinatorProtocol?
  private var onboardingScreenCoordinator: OnboardingScreenCoordinatorProtocol?
  private let window: UIWindow?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  ///   - services: Сервисы приложения
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController,
       _ services: ApplicationServices) {
    self.window = window
    self.navigationController = navigationController
    self.services = services
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenModule = MainScreenAssembly().createModule()
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.showOnboarding()
    }
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func mainScreenDidAppear() {
    services.permissionService.requestNotification { _ in }
  }
  
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
  
  func settingButtonAction() {
    guard let mainScreenModule = mainScreenModule else {
      return
    }
    
    let settingsScreenCoordinator = MainSettingsScreenCoordinator(window,
                                                                  navigationController,
                                                                  services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    settingsScreenCoordinator.start()
    
    settingsScreenCoordinator.updateContentWith(isDarkTheme: mainScreenModule.returnModel().isDarkMode)
    settingsScreenCoordinator.updateContentWith(models: mainScreenModule.returnModel().allSections)
    services.metricsService.track(event: .mainSettingsScreen)
  }
}

// MARK: - MainSettingsScreenCoordinatorOutput

extension MainScreenCoordinator: MainSettingsScreenCoordinatorOutput {
  func didChanged(models: [MainScreenModel.Section]) {
    mainScreenModule?.updateSectionsWith(models: models)
  }
  
  func darkThemeChanged(_ isEnabled: Bool) {
    mainScreenModule?.saveDarkModeStatus(isEnabled)
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func checkDarkMode() {
    guard let isDarkTheme = mainScreenModule?.returnModel().isDarkMode, let window = window else {
      return
    }
    window.overrideUserInterfaceStyle = isDarkTheme ? .dark : .light
  }
  
  func showOnboarding() {
    let actualScreens = OnboardingScreenInteractor.getActualScreens()

    guard !actualScreens.isEmpty else {
      return
    }
    
    let onboardingScreenCoordinator = OnboardingScreenCoordinator(self.navigationController,
                                                                  self.services)
    onboardingScreenCoordinator.start()
    self.onboardingScreenCoordinator = onboardingScreenCoordinator
    self.services.metricsService.track(event: .onboarding)
  }
}
