//
//  SettingsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol SettingsScreenModuleOutput: AnyObject {
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, кнопка `Список чисел` была нажата
  func listOfObjectsAction()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol SettingsScreenModuleInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter typeObject: Тип отображаемого контента
  func setupDefaultsSettings(for typeObject: SettingsScreenType)
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: SettingsScreenModuleOutput? { get set }
}

/// Готовый модуль `SettingsScreenModule`
typealias SettingsScreenModule = UIViewController & SettingsScreenModuleInput

/// Презентер
final class SettingsScreenViewController: SettingsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SettingsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SettingsScreenInteractorInput
  private let moduleView: SettingsScreenViewProtocol
  private let factory: SettingsScreenFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: SettingsScreenInteractorInput,
       moduleView: SettingsScreenViewProtocol,
       factory: SettingsScreenFactoryInput) {
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
    
    title = Appearance().title
  }
  
  // MARK: - Internal func
  
  func setupDefaultsSettings(for typeObject: SettingsScreenType) {
    factory.getContent(from: typeObject)
  }
}

// MARK: - SettingsScreenViewOutput

extension SettingsScreenViewController: SettingsScreenViewOutput {
  func withoutRepetitionAction(isOn: Bool) {
    moduleOutput?.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    moduleOutput?.cleanButtonAction()
  }
  
  func listOfObjectsAction() {
    moduleOutput?.listOfObjectsAction()
  }
}

// MARK: - SettingsScreenInteractorOutput

extension SettingsScreenViewController: SettingsScreenInteractorOutput {
  
}

// MARK: - SettingsScreenFactoryOutput

extension SettingsScreenViewController: SettingsScreenFactoryOutput {
  func didRecive(models: [Any]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Appearance

private extension SettingsScreenViewController {
  struct Appearance {
    let title = "Настройки"
  }
}
