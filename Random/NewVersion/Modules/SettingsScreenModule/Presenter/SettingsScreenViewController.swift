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
  ///  - Parameter model: Модель
  func withoutRepetitionAction(model: SettingsScreenModel)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Событие, кнопка `Список чисел` была нажата
  ///  - Parameter numbers: Массив чисел
  func listOfNumbersAction(numbers: [String])
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol SettingsScreenModuleInput {
  
  /// Установить настройки по умолчанию
  ///  - Parameter model: Модель данных
  func setupDefaultsSettingsFrom(model: SettingsScreenModel)
  
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
  private var cacheModel: SettingsScreenModel?
  
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
  
  func setupDefaultsSettingsFrom(model: SettingsScreenModel) {
    cacheModel = model
    factory.getContentFrom(model: model)
  }
}

// MARK: - SettingsScreenViewOutput

extension SettingsScreenViewController: SettingsScreenViewOutput {
  func withoutRepetitionAction(isOn: Bool) {
    guard let cacheModel = cacheModel else { return }
    let model = SettingsScreenModel(result: cacheModel.result,
                                    listResult: cacheModel.listResult,
                                    isNoRepetition: isOn)
    moduleOutput?.withoutRepetitionAction(model: model)
  }
  
  func cleanButtonAction() {
    let model = SettingsScreenModel(result: "?",
                                    listResult: [],
                                    isNoRepetition: cacheModel?.isNoRepetition ?? false)
    factory.getContentFrom(model: model)
    moduleOutput?.cleanButtonAction()
  }
  
  func listOfNumbersAction() {
    guard let cacheModel = cacheModel else { return }
    moduleOutput?.listOfNumbersAction(numbers: cacheModel.listResult)
  }
}

// MARK: - SettingsScreenInteractorOutput

extension SettingsScreenViewController: SettingsScreenInteractorOutput {
  
}

// MARK: - SettingsScreenFactoryOutput

extension SettingsScreenViewController: SettingsScreenFactoryOutput {
  func didRecive(models: [SettingsScreenCell]) {
    moduleView.updateContentWitch(models: models)
  }
}

// MARK: - Appearance

private extension SettingsScreenViewController {
  struct Appearance {
    let title = "Настройки"
  }
}
