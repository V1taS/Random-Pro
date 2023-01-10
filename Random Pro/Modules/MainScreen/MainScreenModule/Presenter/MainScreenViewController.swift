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

  /// Открыть раздел `raffle`
  func openRaffle()
  
  /// Была нажата кнопка (настройки)
  func settingButtonAction()
  
  /// Кнопка поделиться была нажата
  func shareButtonAction()
  
  /// Главный экран был показан
  func mainScreenModuleDidAppear()
  
  /// Нет премиум доступа
  /// - Parameter section: Секция на главном экране
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section)

  /// Главный экран был загружен
  func mainScreenModuleDidLoad()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainScreenModuleInput {
  
  /// Обновить секции главного экрана
  /// - Parameter models: Список секция
  func updateSectionsWith(models: [MainScreenModel.Section])
  
  /// Сохранить темную тему
  /// - Parameter isEnabled: Темная тема включена
  func saveDarkModeStatus(_ isEnabled: Bool)
  
  /// Возвращает модель
  func returnModel() -> MainScreenModel
  
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
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    moduleOutput?.mainScreenModuleDidAppear()
  }
  
  // MARK: - Internal func

  func saveDarkModeStatus(_ isEnabled: Bool) {
    interactor.saveDarkModeStatus(isEnabled)
  }
  
  func returnModel() -> MainScreenModel {
    interactor.returnModel()
  }
  
  func updateSectionsWith(models: [MainScreenModel.Section]) {
    interactor.updateSectionsWith(models: models)
  }
  
  func removeLabelFromSection(type: MainScreenModel.SectionType) {
    interactor.removeLabelFromSection(type: type)
  }
  
  func addLabel(_ label: MainScreenModel.ADVLabel,
                for sectionType: MainScreenModel.SectionType) {
    interactor.addLabel(label, for: sectionType)
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    moduleOutput?.noPremiumAccessActionFor(section)
  }

  func openRaffle() {
    moduleOutput?.openRaffle()
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
  func didReceive(models: [MainScreenModel.Section]) {
    moduleView.configureCellsWith(models: models)
  }
}

// MARK: - Private

private extension MainScreenViewController {
  func updateSections() {
    interactor.getContent { [weak self] in
      self?.interactor.updatesSectionsIsHiddenFT { [weak self] in
        self?.interactor.updatesLabelsFeatureToggle { [weak self] in

          // TODO: - Обновление премиум фичатогглов в самом конце
          self?.interactor.updatesPremiumFeatureToggle {}
        }
      }
    }
  }

  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.title
    
    let shareButton = UIBarButtonItem(image: appearance.shareButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(shareButtonAction))
    
    navigationItem.rightBarButtonItem = shareButton
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                       style: .plain,
                                                       target: self,
                                                       action: #selector(settingsButtonAction))
  }
  
  @objc
  func shareButtonAction() {
    moduleOutput?.shareButtonAction()
  }
  
  @objc
  func settingsButtonAction() {
    moduleOutput?.settingButtonAction()
  }

  @objc
  func didBecomeActiveNotification() {
    updateSections()
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Random Pro", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
  }
}
