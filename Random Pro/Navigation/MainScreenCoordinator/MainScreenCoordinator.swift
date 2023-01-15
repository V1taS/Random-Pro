//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import StoreKit

/// События которые отправляем из `текущего координатора` в `другой координатор`
protocol MainScreenCoordinatorOutput: AnyObject {}

/// События которые отправляем из `другого координатора` в `текущий координатор`
protocol MainScreenCoordinatorInput {
  
  /// Приложение стало активным
  func sceneDidBecomeActive()
  
  /// События которые отправляем из `текущего координатора` в `другой координатор`
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
    let mainScreenModule = MainScreenAssembly().createModule(services)
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.showOnboarding()
      self?.rateApp()
    }
  }
  
  func sceneDidBecomeActive() {
    startDeepLink()
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func mainScreenModuleDidLoad() {
    checkIsUpdateAvailable()
  }
  
  func mainScreenModuleDidAppear() {
    services.permissionService.requestNotification { _ in }
  }
  
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    showAlerForUnlockPremiumtWith(title: Appearance().premiumAccess,
                                  description: section.type.descriptionForNoPremiumAccess)
  }
  
  func openRaffle() {
    let raffleScreenCoordinator = RaffleScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = raffleScreenCoordinator
    raffleScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .raffle)
    services.metricsService.track(event: .raffle)
  }
  
  func openImageFilters() {
    let imageFiltersScreenCoordinator = ImageFiltersScreenCoordinator(navigationController,
                                                                      services)
    anyCoordinator = imageFiltersScreenCoordinator
    imageFiltersScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .imageFilters)
    services.metricsService.track(event: .imageFilters)
  }
  
  func openRockPaperScissors() {
    let rockPaperScissorsScreenCoordinator = RockPaperScissorsScreenCoordinator(navigationController,
                                                                                services)
    anyCoordinator = rockPaperScissorsScreenCoordinator
    rockPaperScissorsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .rockPaperScissors)
    services.metricsService.track(event: .rockPaperScissors)
  }
  
  func openBottle() {
    let bottleScreenCoordinator = BottleScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = bottleScreenCoordinator
    bottleScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .bottle)
    services.metricsService.track(event: .bottleScreen)
  }
  
  func openColors() {
    let colorsScreenCoordinator = ColorsScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = colorsScreenCoordinator
    colorsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .colors)
    services.metricsService.track(event: .colorsScreen)
  }
  
  func openTeams() {
    let teamsScreenCoordinator = TeamsScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = teamsScreenCoordinator
    teamsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .teams)
    services.metricsService.track(event: .teamsScreen)
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .yesOrNo)
    services.metricsService.track(event: .yesOrNotScreen)
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .letter)
    services.metricsService.track(event: .charactersScreen)
  }
  
  func openList() {
    let listScreenCoordinator = ListScreenCoordinator(navigationController,
                                                      services)
    anyCoordinator = listScreenCoordinator
    listScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .list)
    services.metricsService.track(event: .listScreen)
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController,
                                                      services)
    anyCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .coin)
    services.metricsService.track(event: .coinScreen)
  }
  
  func openCube() {
    let cubesScreenCoordinator = CubesScreenCoordinator(navigationController,
                                                        services)
    anyCoordinator = cubesScreenCoordinator
    cubesScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .cube)
    services.metricsService.track(event: .cubeScreen)
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController,
                                                              services)
    anyCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .dateAndTime)
    services.metricsService.track(event: .dateAndTimeScreen)
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController,
                                                            services)
    anyCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .lottery)
    services.metricsService.track(event: .lotteryScreen)
  }
  
  func openContact() {
    let contactScreenCoordinator = ContactScreenCoordinator(navigationController,
                                                            services)
    anyCoordinator = contactScreenCoordinator
    contactScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .contact)
    services.metricsService.track(event: .contactScreen)
  }
  
  func openPassword() {
    let passwordScreenCoordinator = PasswordScreenCoordinator(navigationController,
                                                              services)
    anyCoordinator = passwordScreenCoordinator
    passwordScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .password)
    services.metricsService.track(event: .passwordScreen)
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController,
                                                          services)
    anyCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .number)
    services.metricsService.track(event: .numbersScreen)
  }
  
  func shareButtonAction() {
    let appearance = Appearance()
    guard let url = appearance.shareAppUrl else {
      return
    }
    
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
  func checkIsUpdateAvailable() {
    #if !DEBUG
    let appearance = Appearance()
    guard let appStoreUrl = appearance.appStoreUrl else {
      return
    }
    
    services.featureToggleServices.getUpdateAppFeatureToggle { [weak self] isUpdateAvailable in
      guard isUpdateAvailable else {
        return
      }
      
      self?.services.updateAppService.checkIsUpdateAvailable { [weak self] result in
        switch result {
        case let .success(model):
          guard model.isUpdateAvailable else {
            return
          }
          
          let title = """
  \(appearance.newVersionText) \(appearance.availableInAppStoreText).
  \(appearance.clickToUpdateAppText)
  """
          self?.services.notificationService.showPositiveAlertWith(title: title,
                                                                   glyph: false,
                                                                   timeout: appearance.timeoutNotification,
                                                                   active: {
            UIApplication.shared.open(appStoreUrl)
          })
        case .failure: break
        }
      }
    }
    #endif
  }
  
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
  
  func startDeepLink() {
    services.deepLinkService.startDeepLink { [weak self] deepLinkType in
      self?.showScreenDeepLinkWith(type: deepLinkType)
    }
  }
  
  func showScreenDeepLinkWith(type deepLinkType: DeepLinkType) {
    guard let mainScreenModule else {
      return
    }
    navigationController.popToViewController(mainScreenModule, animated: false)
    
    switch deepLinkType {
    case .settingsScreen:
      settingButtonAction()
    case .updateApp:
      guard let shareAppUrl = Appearance().shareAppUrl else {
        return
      }
      UIApplication.shared.open(shareAppUrl)
    case .colorsScreen:
      openColors()
    case .teamsScreen:
      openTeams()
    case .yesOrNoScreen:
      openYesOrNo()
    case .characterScreen:
      openCharacter()
    case .listScreen:
      openList()
    case .coinScreen:
      openCoin()
    case .cubeScreen:
      openCube()
    case .dateAndTimeScreen:
      openDateAndTime()
    case .lotteryScreen:
      openLottery()
    case .contactScreen:
      openContact()
    case .passwordScreen:
      openPassword()
    case .numberScreen:
      openNumber()
    case .bottleScreen:
      openBottle()
    case .rockPaperScissorsScreen:
      openRockPaperScissors()
    case .raffleScreen:
      openRaffle()
    case .imageFilters:
      openImageFilters()
    }
    services.metricsService.track(event: .deepLinks,
                                  properties: ["screen": deepLinkType.rawValue])
  }
  
  func rateApp() {
    let appearance = Appearance()
    let appLaunchesCount = UserDefaults.standard.integer(forKey: appearance.rateAppKey) + 1
    UserDefaults.standard.set(appLaunchesCount, forKey: appearance.rateAppKey)
    
    guard appLaunchesCount.isMultiple(of: 30) else {
      return
    }
    
    guard let scene = UIApplication.shared.foregroundActiveScene else { return }
    if #available(iOS 14.0, *) {
      SKStoreReviewController.requestReview(in: scene)
    } else {
      // TODO: - Сделать кастомную реализацию для iOS < 14
      // Note: Replace the XXXXXXXXXX below with the App Store ID for your app
      // https://apps.apple.com/app/idXXXXXXXXXX?action=write-review"
    }
  }
  
  func showAlerForUnlockPremiumtWith(title: String, description: String) {
    let appearance = Appearance()
    let alert = UIAlertController(title: title,
                                  message: description,
                                  preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: appearance.cancel,
                                  style: .cancel,
                                  handler: { _ in }))
    alert.addAction(UIAlertAction(title: appearance.unlock,
                                  style: .default,
                                  handler: { _ in
      // TODO: - Показать экран с разблокировкой премиум
    }))
    mainScreenModule?.present(alert, animated: true, completion: nil)
  }
}

// MARK: - UIApplication

private extension UIApplication {
  var foregroundActiveScene: UIWindowScene? {
    connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
  }
}

// MARK: - Appearance

private extension MainScreenCoordinator {
  struct Appearance {
    let shareAppUrl = URL(string: "https://apps.apple.com/app/random-pro/id1552813956")
    let appStoreUrl = URL(string: "itms-apps://itunes.apple.com/app/id1552813956")
    let rateAppKey = "rate_app_key"
    let cancel = NSLocalizedString("Отмена", comment: "")
    let unlock = NSLocalizedString("Разблокировать", comment: "")
    let premiumAccess = NSLocalizedString("Премиум доступ", comment: "")
    let timeoutNotification: Double = 10
    
    let newVersionText = NSLocalizedString("Новая версия", comment: "")
    let availableInAppStoreText = NSLocalizedString("доступна в App Store", comment: "")
    let clickToUpdateAppText = NSLocalizedString("Нажмите, чтобы обновить приложение", comment: "")
  }
}
