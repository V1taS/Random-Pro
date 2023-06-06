//
//  MainScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainScreenModuleOutput: AnyObject {
  
  /// Открыть раздел `Number`
  func openNumber()
  
  /// Открыть раздел `Teams`
  func openTeams()
  
  /// Открыть раздел `YesOrNo`
  func openYesOrNo()
  
  /// Открыть раздел `Character`
  func openCharacter()
  
  /// Открыть раздел `List`
  func openList()
  
  /// Открыть раздел `Coin`
  func openCoin()
  
  /// Открыть раздел `Cube`
  func openCube()
  
  /// Открыть раздел `DateAndTime`
  func openDateAndTime()
  
  /// Открыть раздел `Lottery`
  func openLottery()
  
  /// Открыть раздел `Contact`
  func openContact()
  
  /// Открыть раздел `Password`
  func openPassword()
  
  /// Открыть раздел `Colors`
  func openColors()
  
  /// Открыть раздел `Bottle`
  func openBottle()
  
  /// Открыть раздел `rockPaperScissors`
  func openRockPaperScissors()
  
  /// Открыть раздел `openImageFilters`
  func openImageFilters()
  
  /// Открыть раздел `Films`
  func openFilms()
  
  /// Открыть раздел `NickName`
  func openNickName()
  
  /// Открыть раздел `Joke`
  func openJoke()
  
  /// Открыть раздел `Names`
  func openNames()
  
  /// Открыть раздел `Добрые дела`
  func openGoodDeeds()
  
  /// Открыть раздел `Поздравления`
  func openCongratulations()
  
  /// Открыть раздел `Загадки`
  func openRiddles()

  // Открыть раздел `Подарки`
  func openGifts()
  
  /// Была нажата кнопка (настройки)
  func settingButtonAction()
  
  /// Кнопка поделиться была нажата
  func shareButtonAction()
  
  /// Главный экран был показан
  func mainScreenModuleDidAppear()
  
  /// Главный экран будет показан
  func mainScreenModuleWillAppear()
  
  /// Нет премиум доступа
  /// - Parameter section: Секция на главном экране
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section)
  
  /// Главный экран был загружен
  func mainScreenModuleDidLoad()
  
  /// Кнопка премиум была нажата
  /// - Parameter isPremium: Включен премиум
  func premiumButtonAction(_ isPremium: Bool)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainScreenModuleInput {
  
  /// Обновить секции главного экрана
  /// - Parameter models: Список секция
  func updateSectionsWith(models: [MainScreenModel.Section])
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool?)
  
  /// Сохранить премиум режим
  /// - Parameter isEnabled: Сохранить премиум режим
  func savePremium(_ isEnabled: Bool)
  
  /// Возвращает модель
  func returnModel(completion: @escaping (MainScreenModel) -> Void)
  
  /// Убрать лайбл с секции
  /// - Parameter type: Тип сеции
  func removeLabelFromSection(type: MainScreenModel.SectionType)
  
  /// Добавить лайбл к секции
  /// - Parameters:
  ///  - label: Лайбл
  ///  - for: Тип сеции
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainScreenModuleOutput? { get set }
}

/// Готовый модуль `MainScreenModule`
typealias MainScreenModule = UIViewController & MainScreenModuleInput

/// Презентер
final class MainScreenViewController: MainScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let moduleView: MainScreenViewProtocol
  private let factory: MainScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var isPremiumDEBUG: Bool?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MainScreenViewProtocol,
       interactor: MainScreenInteractorInput,
       factory: MainScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateSections()
    setupNavBar()
    moduleOutput?.mainScreenModuleDidLoad()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didBecomeActiveNotification),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    moduleOutput?.mainScreenModuleWillAppear()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    moduleOutput?.mainScreenModuleDidAppear()
  }
  
  // MARK: - Internal func
  
  func saveDarkModeStatus(_ isEnabled: Bool?) {
    interactor.saveDarkModeStatus(isEnabled)
  }
  
  func savePremium(_ isEnabled: Bool) {
    interactor.savePremium(isEnabled)
    isPremiumDEBUG = isEnabled
  }
  
  func returnModel(completion: @escaping (MainScreenModel) -> Void) {
    interactor.returnModel(completion: completion)
  }
  
  func updateSectionsWith(models: [MainScreenModel.Section]) {
    interactor.returnModel { [weak self] model in
      let newModel = MainScreenModel(isDarkMode: model.isDarkMode,
                                     isPremium: model.isPremium,
                                     allSections: models)
      self?.interactor.updateSectionsWith(model: newModel)
    }
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    interactor.removeLabelFromSection(type: type)
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    interactor.addLabel(label, for: sectionType)
  }
  
  func updateStateForSections() {
    updateSections()
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func openGifts() {
    moduleOutput?.openGifts()
  }

  func openJoke() {
    moduleOutput?.openJoke()
  }
  
  func openRiddles() {
    moduleOutput?.openRiddles()
  }
  
  func openGoodDeeds() {
    moduleOutput?.openGoodDeeds()
  }
  
  func openCongratulations() {
    moduleOutput?.openCongratulations()
  }
  
  func openNames() {
    moduleOutput?.openNames()
  }
  
  func openNickName() {
    moduleOutput?.openNickName()
  }
  
  func openFilms() {
    moduleOutput?.openFilms()
  }
  
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    moduleOutput?.noPremiumAccessActionFor(section)
  }
  
  func openImageFilters() {
    moduleOutput?.openImageFilters()
  }
  
  func openRockPaperScissors() {
    moduleOutput?.openRockPaperScissors()
  }
  
  func openBottle() {
    moduleOutput?.openBottle()
  }
  
  func openColors() {
    moduleOutput?.openColors()
  }
  
  func openTeams() {
    moduleOutput?.openTeams()
  }
  
  func openYesOrNo() {
    moduleOutput?.openYesOrNo()
  }
  
  func openCharacter() {
    moduleOutput?.openCharacter()
  }
  
  func openList() {
    moduleOutput?.openList()
  }
  
  func openCoin() {
    moduleOutput?.openCoin()
  }
  
  func openCube() {
    moduleOutput?.openCube()
  }
  
  func openDateAndTime() {
    moduleOutput?.openDateAndTime()
  }
  
  func openLottery() {
    moduleOutput?.openLottery()
  }
  
  func openContact() {
    moduleOutput?.openContact()
  }
  
  func openPassword() {
    moduleOutput?.openPassword()
  }
  
  func openNumber() {
    moduleOutput?.openNumber()
  }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenViewController: MainScreenInteractorOutput {
  func didReceive(model: MainScreenModel) {
    factory.createCellsFrom(model: model)
  }
}

// MARK: - MainScreenFactoryOutput

extension MainScreenViewController: MainScreenFactoryOutput {
  func didReceiveNew(model: MainScreenModel) {
    moduleView.configureCellsWith(model: model)
  }
}

// MARK: - Private

private extension MainScreenViewController {
  func updateSections() {
    interactor.getContent { [weak self] in
      self?.interactor.updatesSectionsIsHiddenFT { [weak self] in
        self?.interactor.updatesLabelsFeatureToggle { [weak self] in
          self?.interactor.validatePurchase { [weak self] in
            if self?.isPremiumDEBUG != nil {
              self?.setupNavBar()
            } else {
              self?.interactor.updatesPremiumFeatureToggle { [weak self] in
                self?.setupNavBar()
              }
            }
          }
        }
      }
    }
    
  }
  
  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.title
    
    interactor.returnModel { [weak self] model in
      guard let self else {
        return
      }
      let isPremium = model.isPremium
      let premiumName = isPremium ? appearance.isPremiumName : appearance.notPremiumName
      
      let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(self.shareButtonAction))
      
      let premiumButton = UIBarButtonItem.menuButton(self,
                                                     action: #selector(self.premiumButtonAction),
                                                     imageName: premiumName,
                                                     size: CGSize(width: 34,
                                                                  height: 28))
      
      self.navigationItem.rightBarButtonItems = [shareButton, premiumButton]
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                              style: .plain,
                                                              target: self,
                                                              action: #selector(self.settingsButtonAction))
    }
  }
  
  @objc
  func premiumButtonAction() {
    interactor.returnModel { [weak self] model in
      self?.moduleOutput?.premiumButtonAction(model.isPremium)
      self?.impactFeedback.impactOccurred()
    }
  }
  
  @objc
  func shareButtonAction() {
    moduleOutput?.shareButtonAction()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingsButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
  }
  
  @objc
  func didBecomeActiveNotification() {
    updateSections()
  }
}

// MARK: - UIBarButtonItem

private extension UIBarButtonItem {
  static func menuButton(_ target: Any?,
                         action: Selector,
                         imageName: String,
                         size: CGSize) -> UIBarButtonItem {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    
    let menuBarItem = UIBarButtonItem(customView: button)
    menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
    menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    return menuBarItem
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
    let premiumButtonIcon = UIImage(systemName: "crown")
    
    let notPremiumName = RandomAsset.crownNotPremium.name
    let isPremiumName = RandomAsset.crownIsPremium.name
  }
}
