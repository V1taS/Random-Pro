//
//  MainSettingsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol MainSettingsScreenModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Тема приложения была изменена
  /// - Parameter isEnabled: Темная тема включена
  func darkThemeChanged(_ isEnabled: Bool)
  
  /// Выбран раздел настройки главного экрана
  func customMainSectionsSelected()
  
  /// Выбран раздел выбора иконок
  func applicationIconSectionsSelected()
  
  /// Выбран раздел премиум
  func premiumSectionsSelected()
  
  /// Кнопка обратной связи была нажата
  func feedBackButtonAction()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol MainSettingsScreenModuleInput {
  
  /// Обновить контент
  ///  - Parameter isDarkTheme: Темная тема
  func updateContentWith(isDarkTheme: Bool?)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: MainSettingsScreenModuleOutput? { get set }
}

/// Готовый модуль `MainSettingsScreenModule`
typealias MainSettingsScreenModule = UIViewController & MainSettingsScreenModuleInput

/// Презентер
final class MainSettingsScreenViewController: MainSettingsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: MainSettingsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: MainSettingsScreenInteractorInput
  private let moduleView: MainSettingsScreenViewProtocol
  private let factory: MainSettingsScreenFactoryInput
  
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
  
  // MARK: - Internal func
  
  func updateContentWith(isDarkTheme: Bool?) {
    if let result = isDarkTheme {
      interactor.getContentWith(isDarkMode: result)
    } else {
      interactor.getContentWith(isDarkMode: isDarkMode)
    }
  }
}

// MARK: - MainSettingsScreenViewOutput

extension MainSettingsScreenViewController: MainSettingsScreenViewOutput {
  func applicationIconSectionsSelected() {
    moduleOutput?.applicationIconSectionsSelected()
  }
  
  func premiumSectionsSelected() {
    moduleOutput?.premiumSectionsSelected()
  }
  
  func feedBackButtonAction() {
    moduleOutput?.feedBackButtonAction()
  }
  
  func customMainSectionsSelected() {
    moduleOutput?.customMainSectionsSelected()
  }
  
  func darkThemeChanged(_ isEnabled: Bool) {
    moduleOutput?.darkThemeChanged(isEnabled)
    interactor.darkThemeChanged(isEnabled)
  }
}

// MARK: - MainSettingsScreenInteractorOutput

extension MainSettingsScreenViewController: MainSettingsScreenInteractorOutput {
  func didReceive(model: MainSettingsScreenModel) {
    factory.createListModelWith(isDarkMode: model.isDarkMode)
  }
}

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
  }
}

// MARK: - Appearance

private extension MainSettingsScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Настройки", comment: "")
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
