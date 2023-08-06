//
//  MainSettingsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainSettingsScreenModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func applyDarkTheme(_ isEnabled: Bool?)
  
  /// Премиум режим включен
  /// - Parameter isEnabled: Премиум режим включен
  func applyPremium(_ isEnabled: Bool)
  
  /// Выбран раздел настройки главного экрана
  func customMainSectionsSelected()
  
  /// Выбран раздел выбора иконок
  func applicationIconSectionsSelected()
  
  /// Выбран раздел премиум
  func premiumSectionsSelected()
  
  /// Кнопка обратной связи была нажата
  func feedBackButtonAction()

  /// Кнопка поделиться была нажата
  func shareButtonSelected()
  
  /// Выбрана реферальная программа
  func premiumWithFriendsSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainSettingsScreenModuleInput {
  
  /// Обновить контент
  ///  - Parameter model: Модель данных
  func updateContentWith(model: MainSettingsScreenModel)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainSettingsScreenModuleOutput? { get set }
}

/// Готовый модуль `MainSettingsScreenModule`
typealias MainSettingsScreenModule = ViewController & MainSettingsScreenModuleInput

/// Презентер
final class MainSettingsScreenViewController: MainSettingsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainSettingsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainSettingsScreenInteractorInput
  private let moduleView: MainSettingsScreenViewProtocol
  private let factory: MainSettingsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: MainSettingsScreenViewProtocol,
       interactor: MainSettingsScreenInteractorInput,
       factory: MainSettingsScreenFactoryInput) {
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
    
    setNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(model: MainSettingsScreenModel) {
    factory.createListModelWith(model: model, isPremiumWithFriends: false)
    interactor.getPremiumWithFriendsToggle { [weak self] isPremiumWithFriends in
      self?.factory.createListModelWith(model: model, isPremiumWithFriends: isPremiumWithFriends)
    }
  }
}

// MARK: - MainSettingsScreenViewOutput

extension MainSettingsScreenViewController: MainSettingsScreenViewOutput {
  func premiumWithFriendsSelected() {
    moduleOutput?.premiumWithFriendsSelected()
  }
  
  func shareButtonSelected() {
    moduleOutput?.shareButtonSelected()
  }

  func applyPremium(_ isEnabled: Bool) {
    moduleOutput?.applyPremium(isEnabled)
  }
  
  func applicationIconSectionsSelected() {
    moduleOutput?.applicationIconSectionsSelected()
  }
  
  func premiumSectionsSelected() {
    moduleOutput?.premiumSectionsSelected()
  }
  
  func feedBackButtonAction() {
    moduleOutput?.feedBackButtonAction()
    impactFeedback.impactOccurred()
  }
  
  func customMainSectionsSelected() {
    moduleOutput?.customMainSectionsSelected()
  }
  
  func applyDarkTheme(_ isEnabled: Bool?) {
    moduleOutput?.applyDarkTheme(isEnabled)
  }
}

// MARK: - MainSettingsScreenInteractorOutput

extension MainSettingsScreenViewController: MainSettingsScreenInteractorOutput {}

// MARK: - MainSettingsScreenFactoryOutput

extension MainSettingsScreenViewController: MainSettingsScreenFactoryOutput {
  func didReceive(models: [MainSettingsScreenType]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Private

private extension MainSettingsScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                      style: .plain,
                                      target: self,
                                      action: #selector(closeButtonAction))
    
    navigationItem.rightBarButtonItems = [closeButton]
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension MainSettingsScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.settings
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
