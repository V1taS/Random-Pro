//
//  JokeGeneratorScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol JokeGeneratorScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: JokeGeneratorScreenModel)
  
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
protocol JokeGeneratorScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> JokeGeneratorScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: JokeGeneratorScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: JokeGeneratorScreenModuleOutput? { get set }
}

/// Готовый модуль `JokeGeneratorScreenModule`
typealias JokeGeneratorScreenModule = ViewController & JokeGeneratorScreenModuleInput

/// Презентер
final class JokeGeneratorScreenViewController: JokeGeneratorScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: JokeGeneratorScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: JokeGeneratorScreenInteractorInput
  private let moduleView: JokeGeneratorScreenViewProtocol
  private let factory: JokeGeneratorScreenFactoryInput
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
  init(moduleView: JokeGeneratorScreenViewProtocol,
       interactor: JokeGeneratorScreenInteractorInput,
       factory: JokeGeneratorScreenFactoryInput) {
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
    interactor.getContent()
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> JokeGeneratorScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setNewLanguage(language: JokeGeneratorScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - JokeGeneratorScreenViewOutput

extension JokeGeneratorScreenViewController: JokeGeneratorScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
  }
}

// MARK: - JokeGeneratorScreenInteractorOutput

extension JokeGeneratorScreenViewController: JokeGeneratorScreenInteractorOutput {
  func didReceive(text: String?) {
    moduleView.stopLoader()
    moduleView.set(result: text)
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

// MARK: - JokeGeneratorScreenFactoryOutput

extension JokeGeneratorScreenViewController: JokeGeneratorScreenFactoryOutput {}

// MARK: - Private

private extension JokeGeneratorScreenViewController {
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

private extension JokeGeneratorScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.joke
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
