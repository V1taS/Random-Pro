//
//  MainScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol MainScreenModuleOutput: AnyObject {
  
  /// Открыть раздел `Number`
  func openNumber()
  
  /// Открыть раздел `Films`
  func openFilms()
  
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
  
  /// Открыть админ-панель фича тоглов
  func adminFeatureToggleAction()
  
  /// Запрос на отслеживание
  func requestIDFA()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol MainScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
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
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: MainScreenInteractorInput,
       moduleView: MainScreenViewProtocol,
       factory: MainScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
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
    
    interactor.getCells()
    setupNavBar()
    moduleOutput?.requestIDFA()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.prefersLargeTitles = true
  }
}

// MARK: - MainScreenViewOutput

extension MainScreenViewController: MainScreenViewOutput {
  func openFilms() {
    moduleOutput?.openFilms()
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
  func didRecive(cells: [MainScreenCellModel.MainScreenCell]) {
    factory.createModelsFrom(cells: cells)
  }
}

// MARK: - MainScreenFactoryOutput

extension MainScreenViewController: MainScreenFactoryOutput {
  func didRecive(models: [MainScreenCellModel]) {
    moduleView.configureCellsWith(models: models)
  }
}

// MARK: - Private

private extension MainScreenViewController {
  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.title
    
    let adminFeatureToggleImageView = UIImageView()
    adminFeatureToggleImageView.image = appearance.adminFeatureToggleIcon
    let adminFeatureToggleTap = UITapGestureRecognizer(target: self,
                                                       action: #selector(adminFeatureToggleAction))
    adminFeatureToggleTap.numberOfTapsRequired = appearance.numberOfTapsRequired
    adminFeatureToggleImageView.addGestureRecognizer(adminFeatureToggleTap)
    adminFeatureToggleImageView.isUserInteractionEnabled = true
    adminFeatureToggleTap.cancelsTouchesInView = false
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: adminFeatureToggleImageView)
  }
  
  @objc
  func adminFeatureToggleAction() {
    moduleOutput?.adminFeatureToggleAction()
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    //    let title = "Random"
    let title = "Random (БЕТА)"
    let adminFeatureToggleIcon = UIImage(named: "Empty")
    let numberOfTapsRequired = 10
  }
}
