//
//  MainScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.05.2022.
//

import UIKit
import FancyUIKit
import FancyStyle
import SKAbstractions

/// Презентер
final class MainScreenViewController: MainScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainScreenInteractorInput
  private let moduleView: MainScreenViewProtocol
  private let factory: MainScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
    moduleOutput?.mainScreenModuleDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
    setupNavBar()
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
    setupNavBar()
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
  func openADV(urlString: String?) {
    moduleOutput?.openADV(urlString: urlString)
  }
  
  func openMemes() {
    moduleOutput?.openMemes()
  }
  
  func openFortuneWheel() {
    moduleOutput?.openFortuneWheel()
  }

  func openGifts() {
    moduleOutput?.openGifts()
  }
  
  func openJoke() {
    moduleOutput?.openJoke()
  }
  
  func openCongratulations() {
    moduleOutput?.openCongratulations()
  }
  
  func openNames() {
    moduleOutput?.openNames()
  }
  
  func openFilms() {
    moduleOutput?.openFilms()
  }
  
  func noPremiumAccessActionFor(_ section: MainScreenModel.Section) {
    moduleOutput?.noPremiumAccessActionFor(section)
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
      self?.setupNavBar()
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
      let style: PremiumButtonView.Style = isPremium ? .premium : .nonPremium
      
      let premiumButton = UIBarButtonItem.premiumButton(self,
                                                        action: #selector(self.premiumButtonAction),
                                                        style: style)
      
      self.navigationItem.rightBarButtonItems = [premiumButton]
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
  func settingsButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - UIBarButtonItem

private extension UIBarButtonItem {
  static func premiumButton(_ target: Any?,
                            action: Selector,
                            style: PremiumButtonView.Style) -> UIBarButtonItem {
    let button = PremiumButtonView()
    button.addTarget(target, action: action, for: .touchUpInside)
    button.configureWith(title: RandomStrings.Localizable.premium, style: style)
    
    let menuBarItem = UIBarButtonItem(customView: button)
    return menuBarItem
  }
}

// MARK: - Appearance

private extension MainScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
    
    let notPremiumName = RandomAsset.crownNotPremium.name
    let isPremiumName = RandomAsset.crownIsPremium.name
  }
}
