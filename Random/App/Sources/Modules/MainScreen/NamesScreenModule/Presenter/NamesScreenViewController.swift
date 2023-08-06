//
//  NamesScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol NamesScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: NamesScreenModel)
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol NamesScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> NamesScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: NamesScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: NamesScreenModuleOutput? { get set }
}

/// Готовый модуль `NamesScreenModule`
typealias NamesScreenModule = ViewController & NamesScreenModuleInput

/// Презентер
final class NamesScreenViewController: NamesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: NamesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: NamesScreenInteractorInput
  private let moduleView: NamesScreenViewProtocol
  private let factory: NamesScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private lazy var copyButton = UIBarButtonItem(image: Appearance().copyButtonIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(copyButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: NamesScreenViewProtocol,
       interactor: NamesScreenInteractorInput,
       factory: NamesScreenFactoryInput) {
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
    moduleView.startLoader()
    interactor.getContent(gender: nil)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnCurrentModel() -> NamesScreenModel {
    interactor.returnCurrentModel()
  }
  
  func setNewLanguage(language: NamesScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - NamesScreenViewOutput

extension NamesScreenViewController: NamesScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
  
  func segmentedControlValueDidChange(type: NamesScreenModel.Gender) {
    interactor.segmentedControlValueDidChange(type: type)
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
  }
}

// MARK: - NamesScreenInteractorOutput

extension NamesScreenViewController: NamesScreenInteractorOutput {
  func didReceive(name: String?, gender: NamesScreenModel.Gender) {
    moduleView.stopLoader()
    moduleView.set(result: name, gender: gender)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  func somethingWentWrong() {
    moduleView.stopLoader()
    moduleOutput?.somethingWentWrong()
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
}

// MARK: - NamesScreenFactoryOutput

extension NamesScreenViewController: NamesScreenFactoryOutput {}

// MARK: - Private

private extension NamesScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      copyButton
    ]
  }
  
  @objc
  func copyButtonAction() {
    moduleOutput?.resultCopied(text: interactor.returnCurrentModel().result)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension NamesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.names
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
