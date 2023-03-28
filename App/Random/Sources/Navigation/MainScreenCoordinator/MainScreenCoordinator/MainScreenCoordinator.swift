//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import StoreKit
import MainScreenModule
import YandexMobileMetrica
import FirebaseAnalytics
import FirebaseFirestore
import AppPurchasesService
import StorageService
import NotificationService
import PermissionService
import DeepLinkService
import MetricsService
import FeatureToggleServices

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
  private var anyCoordinator: Coordinator?
  private var settingsScreenCoordinator: MainSettingsScreenCoordinatorProtocol?
  private let window: UIWindow?
  private let notificationService = NotificationServiceImpl()
  private let permissionService = PermissionServiceImpl()
  private let deepLinkService = DeepLinkServiceImpl()
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - window: Окно просмотра
  ///   - navigationController: UINavigationController
  init(_ window: UIWindow?,
       _ navigationController: UINavigationController) {
    self.window = window
    self.navigationController = navigationController
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenModule = MainScreenAssembly().createModule(featureToggleServices: MainScreenFeatureToggle(),
                                                             storageService: StorageServiceImpl(),
                                                             appPurchasesService: AppPurchasesServiceImpl())
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.rateApp()
    }
  }
  
  func sceneDidBecomeActive() {
    startDeepLink()
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func openFilms() {
    let filmsScreenCoordinator = FilmsScreenCoordinator(navigationController)
    anyCoordinator = filmsScreenCoordinator
    filmsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .films)
    track(event: .filmScreen)
  }
  
  func premiumButtonAction(_ isPremium: Bool) {
    if isPremium {
      notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
                                                glyph: true,
                                                timeout: nil,
                                                active: {})
    } else {
      openPremium()
    }
  }
  
  func mainScreenModuleDidLoad() {
    checkIsUpdateAvailable()
  }
  
  func mainScreenModuleDidAppear() {
    permissionService.requestNotification { _ in }
  }
  
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    showAlerForUnlockPremiumtWith(title: Appearance().premiumAccess,
                                  description: section.type.descriptionForNoPremiumAccess)
  }
  
  func openImageFilters() {
    let imageFiltersScreenCoordinator = ImageFiltersScreenCoordinator(navigationController)
    anyCoordinator = imageFiltersScreenCoordinator
    imageFiltersScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .imageFilters)
    track(event: .imageFilters)
  }
  
  func openRockPaperScissors() {
    let rockPaperScissorsScreenCoordinator = RockPaperScissorsScreenCoordinator(navigationController)
    anyCoordinator = rockPaperScissorsScreenCoordinator
    rockPaperScissorsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .rockPaperScissors)
    track(event: .rockPaperScissors)
    
    rockPaperScissorsScreenCoordinator.interface(style: window?.overrideUserInterfaceStyle)
  }
  
  func openBottle() {
    let bottleScreenCoordinator = BottleScreenCoordinator(navigationController)
    anyCoordinator = bottleScreenCoordinator
    bottleScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .bottle)
    track(event: .bottleScreen)
  }
  
  func openColors() {
    let colorsScreenCoordinator = ColorsScreenCoordinator(navigationController)
    anyCoordinator = colorsScreenCoordinator
    colorsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .colors)
    track(event: .colorsScreen)
  }
  
  func openTeams() {
    let teamsScreenCoordinator = TeamsScreenCoordinator(navigationController)
    anyCoordinator = teamsScreenCoordinator
    teamsScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .teams)
    track(event: .teamsScreen)
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController)
    anyCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .yesOrNo)
    track(event: .yesOrNotScreen)
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController)
    anyCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .letter)
    track(event: .charactersScreen)
  }
  
  func openList() {
    let listScreenCoordinator = ListScreenCoordinator(navigationController)
    anyCoordinator = listScreenCoordinator
    listScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .list)
    track(event: .listScreen)
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController)
    anyCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .coin)
    track(event: .coinScreen)
  }
  
  func openCube() {
    let cubesScreenCoordinator = CubesScreenCoordinator(navigationController)
    anyCoordinator = cubesScreenCoordinator
    cubesScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .cube)
    track(event: .cubeScreen)
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController)
    anyCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .dateAndTime)
    track(event: .dateAndTimeScreen)
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController)
    anyCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .lottery)
    track(event: .lotteryScreen)
  }
  
  func openContact() {
    let contactScreenCoordinator = ContactScreenCoordinator(navigationController)
    anyCoordinator = contactScreenCoordinator
    contactScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .contact)
    track(event: .contactScreen)
  }
  
  func openPassword() {
    let passwordScreenCoordinator = PasswordScreenCoordinator(navigationController)
    anyCoordinator = passwordScreenCoordinator
    passwordScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .password)
    track(event: .passwordScreen)
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController)
    anyCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
    
    mainScreenModule?.removeLabelFromSection(type: .number)
    track(event: .numbersScreen)
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
    track(event: .shareApp)
  }
  
  func settingButtonAction() {
    guard let mainScreenModule = mainScreenModule else {
      return
    }
    
    let settingsScreenCoordinator = MainSettingsScreenCoordinator(window,
                                                                  navigationController)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    self.settingsScreenCoordinator?.output = self
    settingsScreenCoordinator.start()
    track(event: .mainSettingsScreen)
    
    mainScreenModule.returnModel { model in
      settingsScreenCoordinator.updateContentWith(isDarkTheme: model.isDarkMode)
      settingsScreenCoordinator.updateContentWith(models: model.allSections)
    }
  }
}

// MARK: - MainSettingsScreenCoordinatorOutput & PremiumScreenCoordinatorOutput

extension MainScreenCoordinator: MainSettingsScreenCoordinatorOutput, PremiumScreenCoordinatorOutput {
  func updateMainScreenWith(isPremium: Bool) {
    mainScreenModule?.updateMainScreenWith(isPremium: isPremium)
  }
  
  func updateStateForSections() {
    mainScreenModule?.updateStateForSections()
  }
  
  func didChanged(models: [MainScreenModel.Section]) {
    mainScreenModule?.updateSectionsWith(models: models)
  }
  
  func darkThemeChanged(_ isEnabled: Bool) {
    mainScreenModule?.saveDarkModeStatus(isEnabled)
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func openPremium() {
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController)
    anyCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    track(event: .premiumScreen)
  }
  
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
    mainScreenModule?.returnModel { [weak self] model in
      guard let self, let isDarkTheme = model.isDarkMode, let window = self.window else {
        return
      }
      window.overrideUserInterfaceStyle = isDarkTheme ? .dark : .light
    }
  }
  
  func startDeepLink() {
    deepLinkService.startDeepLink { [weak self] deepLinkType in
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
    case .imageFilters:
      openImageFilters()
    case .premiumScreen:
      openPremium()
    case .filmsScreen:
      openFilms()
    }
    track(event: .deepLinks,
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
                                  handler: { [weak self] _ in
      self?.openPremium()
    }))
    mainScreenModule?.present(alert, animated: true, completion: nil)
  }
  
  func track(event: MetricsSections) {
    Analytics.logEvent(event.rawValue, parameters: nil)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: nil) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
  
  func track(event: MetricsSections, properties: [String: String]) {
    Analytics.logEvent(event.rawValue, parameters: properties)
    
    YMMYandexMetrica.reportEvent(event.rawValue, parameters: properties) { error in
      print("REPORT ERROR: %@", error.localizedDescription)
    }
  }
}

// MARK: - UIApplication

private extension UIApplication {
  var foregroundActiveScene: UIWindowScene? {
    connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
  }
}

// MARK: - Adapter ApphudProductModel

extension ApphudProductModel: MainScreenApphudProductProtocol {}

// MARK: - Adapter AppPurchasesServiceState

extension AppPurchasesServiceState: MainScreenAppPurchasesServiceStateProtocol {}

// MARK: - Adapter AppPurchasesService

extension AppPurchasesServiceImpl: MainScreenAppPurchasesServiceProtocol {
  public func getProductsForMain(completion: @escaping ([MainScreenApphudProductProtocol]?) -> Void) {
    getProducts(completion: completion)
  }
  
  public func purchaseWithForMain(_ product: MainScreenApphudProductProtocol,
                                  completion: @escaping (MainScreenAppPurchasesServiceStateProtocol) -> Void) {
    guard let product = product as? ApphudProductModel else {
      return
    }
    self.purchaseWith(product, completion: completion)
  }
}

// MARK: - Adapter StorageService

extension StorageServiceImpl: MainScreenStorageServiceProtocol {}

// MARK: - Adapter SectionsIsHiddenFTModel

extension SectionsIsHiddenFTModel: MainScreenSectionsIsHiddenFTModelProtocol {}

// MARK: - Adapter LabelsFeatureToggleModel

extension LabelsFeatureToggleModel: MainScreenLabelsFeatureToggleModelProtocol {}

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
    let premiumAccessActivatedTitle = NSLocalizedString("Премиум доступ активирован", comment: "")
    
    let positiveAlertALotOfClicksKey = "main_screen_show_positive_alert_a_lot_of_clicks"
  }
}
