//
//  MainScreenCoordinator.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import StoreKit
import FancyNetwork
import SafariServices
import SKAbstractions

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

// swiftlint:disable file_length
final class MainScreenCoordinator: MainScreenCoordinatorProtocol {
  
  // MARK: - Internal variables
  
  var finishFlow: (() -> Void)?
  weak var output: MainScreenCoordinatorOutput?
  
  // MARK: - Private variables
  
  private let navigationController: UINavigationController
  private var mainScreenModule: MainScreenModule?
  private let services: ApplicationServices
  private let window: UIWindow?
  
  // Coordinators
  private var appUnavailableCoordinator: AppUnavailableCoordinator?
  private var forceUpdateAppCoordinator: ForceUpdateAppCoordinator?
  private var premiumScreenCoordinator: PremiumScreenCoordinator?
  private var memesScreenCoordinator: MemesScreenCoordinator?
  private var fortuneWheelCoordinator: FortuneWheelCoordinator?
  private var giftsScreenCoordinator: GiftsScreenCoordinator?
  private var jokeGeneratorScreenCoordinator: JokeGeneratorScreenCoordinator?
  private var congratulationsScreenCoordinator: CongratulationsScreenCoordinator?
  private var namesScreenCoordinator: NamesScreenCoordinator?
  private var filmsScreenCoordinator: FilmsScreenCoordinator?
  private var bottleScreenCoordinator: BottleScreenCoordinator?
  private var colorsScreenCoordinator: ColorsScreenCoordinator?
  private var teamsScreenCoordinator: TeamsScreenCoordinator?
  private var yesNoScreenCoordinator: YesNoScreenCoordinator?
  private var letterScreenCoordinator: LetterScreenCoordinator?
  private var listScreenCoordinator: ListScreenCoordinator?
  private var coinScreenCoordinator: CoinScreenCoordinator?
  private var cubesScreenCoordinator: CubesScreenCoordinator?
  private var dateTimeScreenCoordinator: DateTimeScreenCoordinator?
  private var lotteryScreenCoordinator: LotteryScreenCoordinator?
  private var contactScreenCoordinator: ContactScreenCoordinator?
  private var passwordScreenCoordinator: PasswordScreenCoordinator?
  private var numberScreenCoordinator: NumberScreenCoordinator?
  private var settingsScreenCoordinator: MainSettingsScreenCoordinator?
  
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
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appDidEnterForeground),
      name: UIApplication.willEnterForegroundNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(notificationPremiumFeatureToggles(_:)),
      name: Notification.Name(SecretsAPI.notificationPremiumFeatureToggles),
      object: nil
    )
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  // MARK: - Internal func
  
  func start() {
    let mainScreenModule = MainScreenAssembly().createModule(services)
    self.mainScreenModule = mainScreenModule
    self.mainScreenModule?.moduleOutput = self
    
    incrementCounterOnScreenOpen()
    checkDarkMode()
    navigationController.pushViewController(mainScreenModule, animated: true)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.rateApp()
    }
  }
  
  func sceneDidBecomeActive() {}
  
  // Метод, который будет вызван при переходе в foreground
  @objc
  func appDidEnterForeground() {
    salePremium()
    incrementCounterOnScreenOpen()
  }
  @objc
  func notificationPremiumFeatureToggles(_ notification: Notification) {
    mainScreenModule?.updateStateForSections()
  }
}

// MARK: - MainScreenModuleOutput

extension MainScreenCoordinator: MainScreenModuleOutput {
  func openADV(urlString: String?) {
    openSafariWith(url: urlString)
  }
  
  func mainScreenModuleDidLoad() {
    checkIsUpdateAvailable()
    if self.services.featureToggleServices.isToggleFor(feature: .isAppBroken) {
      self.appBroken()
      return
    }
    
    if self.services.featureToggleServices.isToggleFor(feature: .isForceUpdateAvailable) {
      self.forceUpdateAvailable()
      return
    }
  }
  
  func mainScreenModuleDidAppear() {
    services.permissionService.requestNotification { _ in }
  }
  
  func premiumButtonAction(_ isPremium: Bool) {
    if isPremium {
      services.notificationService.showPositiveAlertWith(title: Appearance().premiumAccessActivatedTitle,
                                                         glyph: true,
                                                         timeout: nil,
                                                         active: {})
    } else {
      openPremium()
    }
  }
  
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    showAlerForUnlockPremiumtWith(title: Appearance().premiumAccess,
                                  description: section.type.descriptionForNoPremiumAccess)
  }
  
  func openMemes() {
    let memesScreenCoordinator = MemesScreenCoordinator(navigationController, services)
    self.memesScreenCoordinator = memesScreenCoordinator
    memesScreenCoordinator.start()
    memesScreenCoordinator.finishFlow = { [weak self] in
      self?.memesScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .memes)
  }
  
  func openFortuneWheel() {
    let fortuneWheelCoordinator = FortuneWheelCoordinator(navigationController, services)
    self.fortuneWheelCoordinator = fortuneWheelCoordinator
    fortuneWheelCoordinator.start()
    fortuneWheelCoordinator.finishFlow = { [weak self] in
      self?.fortuneWheelCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .fortuneWheel)
  }
  
  func openGifts() {
    let giftsScreenCoordinator = GiftsScreenCoordinator(navigationController, services)
    
    self.giftsScreenCoordinator = giftsScreenCoordinator
    giftsScreenCoordinator.start()
    giftsScreenCoordinator.finishFlow = { [weak self] in
      self?.giftsScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .gifts)
  }
  
  func openJoke() {
    let jokeGeneratorScreenCoordinator = JokeGeneratorScreenCoordinator(navigationController,
                                                                        services)
    self.jokeGeneratorScreenCoordinator = jokeGeneratorScreenCoordinator
    jokeGeneratorScreenCoordinator.start()
    jokeGeneratorScreenCoordinator.finishFlow = { [weak self] in
      self?.jokeGeneratorScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .joke)
  }
  
  func openCongratulations() {
    let congratulationsScreenCoordinator = CongratulationsScreenCoordinator(navigationController,
                                                                            services)
    self.congratulationsScreenCoordinator = congratulationsScreenCoordinator
    congratulationsScreenCoordinator.start()
    congratulationsScreenCoordinator.finishFlow = { [weak self] in
      self?.congratulationsScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .congratulations)
  }
  
  func openNames() {
    let namesScreenCoordinator = NamesScreenCoordinator(navigationController,
                                                        services)
    self.namesScreenCoordinator = namesScreenCoordinator
    namesScreenCoordinator.start()
    namesScreenCoordinator.finishFlow = { [weak self] in
      self?.namesScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .names)
  }
  
  func openFilms() {
    let filmsScreenCoordinator = FilmsScreenCoordinator(navigationController,
                                                        services)
    self.filmsScreenCoordinator = filmsScreenCoordinator
    filmsScreenCoordinator.start()
    filmsScreenCoordinator.finishFlow = { [weak self] in
      self?.filmsScreenCoordinator = nil
    }

    mainScreenModule?.removeLabelFromSection(type: .films)
  }
  
  func openBottle() {
    let bottleScreenCoordinator = BottleScreenCoordinator(navigationController,
                                                          services)
    self.bottleScreenCoordinator = bottleScreenCoordinator
    bottleScreenCoordinator.start()
    bottleScreenCoordinator.finishFlow = { [weak self] in
      self?.bottleScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .bottle)
  }
  
  func openColors() {
    let colorsScreenCoordinator = ColorsScreenCoordinator(navigationController,
                                                          services)
    self.colorsScreenCoordinator = colorsScreenCoordinator
    colorsScreenCoordinator.start()
    colorsScreenCoordinator.finishFlow = { [weak self] in
      self?.colorsScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .colors)
  }
  
  func openTeams() {
    let teamsScreenCoordinator = TeamsScreenCoordinator(navigationController,
                                                        services)
    self.teamsScreenCoordinator = teamsScreenCoordinator
    teamsScreenCoordinator.start()
    teamsScreenCoordinator.finishFlow = { [weak self] in
      self?.teamsScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .teams)
  }
  
  func openYesOrNo() {
    let yesNoScreenCoordinator = YesNoScreenCoordinator(navigationController,
                                                        services)
    self.yesNoScreenCoordinator = yesNoScreenCoordinator
    yesNoScreenCoordinator.start()
    yesNoScreenCoordinator.finishFlow = { [weak self] in
      self?.yesNoScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .yesOrNo)
  }
  
  func openCharacter() {
    let letterScreenCoordinator = LetterScreenCoordinator(navigationController,
                                                          services)
    self.letterScreenCoordinator = letterScreenCoordinator
    letterScreenCoordinator.start()
    letterScreenCoordinator.finishFlow = { [weak self] in
      self?.letterScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .letter)
  }
  
  func openList() {
    let listScreenCoordinator = ListScreenCoordinator(navigationController,
                                                      services)
    self.listScreenCoordinator = listScreenCoordinator
    listScreenCoordinator.start()
    listScreenCoordinator.finishFlow = { [weak self] in
      self?.listScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .list)
  }
  
  func openCoin() {
    let coinScreenCoordinator = CoinScreenCoordinator(navigationController,
                                                      services)
    self.coinScreenCoordinator = coinScreenCoordinator
    coinScreenCoordinator.start()
    coinScreenCoordinator.finishFlow = { [weak self] in
      self?.coinScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .coin)
  }
  
  func openCube() {
    let cubesScreenCoordinator = CubesScreenCoordinator(navigationController,
                                                        services)
    self.cubesScreenCoordinator = cubesScreenCoordinator
    cubesScreenCoordinator.start()
    cubesScreenCoordinator.finishFlow = { [weak self] in
      self?.cubesScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .cube)
  }
  
  func openDateAndTime() {
    let dateTimeScreenCoordinator = DateTimeScreenCoordinator(navigationController,
                                                              services)
    self.dateTimeScreenCoordinator = dateTimeScreenCoordinator
    dateTimeScreenCoordinator.start()
    dateTimeScreenCoordinator.finishFlow = { [weak self] in
      self?.dateTimeScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .dateAndTime)
  }
  
  func openLottery() {
    let lotteryScreenCoordinator = LotteryScreenCoordinator(navigationController,
                                                            services)
    self.lotteryScreenCoordinator = lotteryScreenCoordinator
    lotteryScreenCoordinator.start()
    lotteryScreenCoordinator.finishFlow = { [weak self] in
      self?.lotteryScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .lottery)
  }
  
  func openContact() {
    let contactScreenCoordinator = ContactScreenCoordinator(navigationController,
                                                            services)
    self.contactScreenCoordinator = contactScreenCoordinator
    contactScreenCoordinator.start()
    contactScreenCoordinator.finishFlow = { [weak self] in
      self?.contactScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .contact)
  }
  
  func openPassword() {
    let passwordScreenCoordinator = PasswordScreenCoordinator(navigationController,
                                                              services)
    self.passwordScreenCoordinator = passwordScreenCoordinator
    passwordScreenCoordinator.start()
    passwordScreenCoordinator.finishFlow = { [weak self] in
      self?.passwordScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .password)
  }
  
  func openNumber() {
    let numberScreenCoordinator = NumberScreenCoordinator(navigationController,
                                                          services)
    self.numberScreenCoordinator = numberScreenCoordinator
    numberScreenCoordinator.start()
    numberScreenCoordinator.finishFlow = { [weak self] in
      self?.numberScreenCoordinator = nil
    }
    
    mainScreenModule?.removeLabelFromSection(type: .number)
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
  }
  
  func settingButtonAction() {
    guard let mainScreenModule = mainScreenModule else {
      return
    }
    
    let settingsScreenCoordinator = MainSettingsScreenCoordinator(window,
                                                                  navigationController,
                                                                  services)
    self.settingsScreenCoordinator = settingsScreenCoordinator
    settingsScreenCoordinator.output = self
    settingsScreenCoordinator.start()
    settingsScreenCoordinator.finishFlow = { [weak self] in
      self?.settingsScreenCoordinator = nil
    }
    
    mainScreenModule.returnModel { model in
      settingsScreenCoordinator.updateContentWith(model: MainSettingsScreenModel(
        isDarkMode: model.isDarkMode,
        isPremium: model.isPremium
      ))
      settingsScreenCoordinator.updateContentWith(models: model.allSections)
    }
  }
}

// MARK: - MainSettingsScreenCoordinatorOutput & PremiumScreenCoordinatorOutput

extension MainScreenCoordinator: MainSettingsScreenCoordinatorOutput, PremiumScreenCoordinatorOutput {
  func applyPremium(_ isEnabled: Bool) {
    mainScreenModule?.savePremium(isEnabled)
  }
  
  func updateStateForSections() {
    mainScreenModule?.updateStateForSections()
  }
  
  func didChanged(models: [MainScreenModel.Section]) {
    mainScreenModule?.updateSectionsWith(models: models)
  }
  
  func applyDarkTheme(_ isEnabled: Bool?) {
    mainScreenModule?.saveDarkModeStatus(isEnabled)
  }
}

// MARK: - Private

private extension MainScreenCoordinator {
  func incrementCounterOnScreenOpen() {
    var count = getCounterOnScreenOpen()
    count += 1
    UserDefaults.standard.set(count, forKey: "SalePremiumKey")
  }
  
  func getCounterOnScreenOpen() -> Int {
    return UserDefaults.standard.integer(forKey: "SalePremiumKey")
  }

  func salePremium() {
    guard services.featureToggleServices.isToggleFor(feature: .isLifetimeSale) else {
      return
    }
    let count = getCounterOnScreenOpen()

    Task { [weak self] in
      guard let self else { return }
      let isValidate = await services.appPurchasesService.restorePurchase()
      guard !isValidate, count.isMultiple(of: 10) else { return }

      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        openPremium(isLifetimeSale: true)
      }
    }
  }
  
  func forceUpdateAvailable() {
#if !DEBUG
    services.updateAppService.checkIsUpdateAvailable(isOneCheckVersion: false) { [weak self] result in
      switch result {
      case let .success(model):
        guard let self, model.isUpdateAvailable else {
          return
        }
        
        let forceUpdateAppCoordinator = ForceUpdateAppCoordinator(
          navigationController: self.navigationController,
          services: self.services
        )
        self.forceUpdateAppCoordinator = forceUpdateAppCoordinator
        forceUpdateAppCoordinator.start()
        forceUpdateAppCoordinator.finishFlow = { [weak self] in
          self?.forceUpdateAppCoordinator = nil
        }
        
        self.services.metricsService.track(event: .forceUpdateApp)
      case .failure: break
      }
    }
#endif
  }
  
  func appBroken() {
#if !DEBUG
    let appUnavailableCoordinator = AppUnavailableCoordinator(navigationController: navigationController,
                                                              services: services)
    self.appUnavailableCoordinator = appUnavailableCoordinator
    appUnavailableCoordinator.start()
    appUnavailableCoordinator.finishFlow = { [weak self] in
      self?.appUnavailableCoordinator = nil
    }
    
    services.metricsService.track(event: .appUnavailable)
#endif
  }
  
  func openPremium(isLifetimeSale: Bool = false) {
    let premiumScreenCoordinator = PremiumScreenCoordinator(navigationController,
                                                            services)
    self.premiumScreenCoordinator = premiumScreenCoordinator
    premiumScreenCoordinator.output = self
    premiumScreenCoordinator.setLifetimeSale(isLifetimeSale)
    premiumScreenCoordinator.selectPresentType(.present)
    premiumScreenCoordinator.start()
    premiumScreenCoordinator.finishFlow = { [weak self] in
      self?.premiumScreenCoordinator = nil
    }
  }
  
  func checkIsUpdateAvailable() {
#if !DEBUG
    let appearance = Appearance()
    guard let appStoreUrl = appearance.appStoreUrl,
          services.featureToggleServices.isToggleFor(feature: .isUpdateAvailable) else {
      return
    }
    
    services.updateAppService.checkIsUpdateAvailable(isOneCheckVersion: true) { [weak self] result in
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
  
  func openSafariWith(url: String?) {
    guard let url,
          let encodedTexts = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let filmUrl = URL(string: encodedTexts) else {
      somethingWentWrong()
      return
    }
    
    let safariViewController = SFSafariViewController(url: filmUrl)
    navigationController.present(safariViewController, animated: true, completion: nil)
  }
  
  func somethingWentWrong() {
    services.notificationService.showNegativeAlertWith(title: RandomStrings.Localizable.somethingWentWrong,
                                                       glyph: false,
                                                       timeout: nil,
                                                       active: {})
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
    let cancel = RandomStrings.Localizable.cancel
    let unlock = RandomStrings.Localizable.unlock
    let premiumAccess = RandomStrings.Localizable.premiumAccess
    let timeoutNotification: Double = 10
    
    let newVersionText = RandomStrings.Localizable.newVersion
    let availableInAppStoreText = RandomStrings.Localizable.availableInAppStore
    let clickToUpdateAppText = RandomStrings.Localizable.clickToUpdateApp
    let premiumAccessActivatedTitle = RandomStrings.Localizable.premiumAccessActivated
    
    let positiveAlertALotOfClicksKey = "main_screen_show_positive_alert_a_lot_of_clicks"
    let advertisingCount = 15
    let refCountMax = 5
  }
}
