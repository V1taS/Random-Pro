//
//  SlogansScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 08.06.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol SlogansScreenModuleOutput: AnyObject {

  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: SlogansScreenModel)

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
protocol SlogansScreenModuleInput {

  /// Запросить текущую модель
  func returnCurrentModel() -> SlogansScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Установить новый язык
  func setNewLanguage(language: SlogansScreenModel.Language)

  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: SlogansScreenModuleOutput? { get set }
}

/// Готовый модуль `SlogansScreenModule`
typealias SlogansScreenModule = ViewController & SlogansScreenModuleInput

/// Презентер
final class SlogansScreenViewController: SlogansScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SlogansScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SlogansScreenInteractorInput
  private let moduleView: SlogansScreenViewProtocol
  private let factory: SlogansScreenFactoryInput
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
  init(moduleView: SlogansScreenViewProtocol,
       interactor: SlogansScreenInteractorInput,
       factory: SlogansScreenFactoryInput) {
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

  func returnCurrentModel() -> SlogansScreenModel {
    interactor.returnCurrentModel()
  }

  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }

  func setNewLanguage(language: SlogansScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - SlogansScreenViewOutput

extension SlogansScreenViewController: SlogansScreenViewOutput {
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

// MARK: - SlogansScreenInteractorOutput

extension SlogansScreenViewController: SlogansScreenInteractorOutput {
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

// MARK: - SlogansScreenFactoryOutput

extension SlogansScreenViewController: SlogansScreenFactoryOutput {}

// MARK: - Private

private extension SlogansScreenViewController {
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

private extension SlogansScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.slogans
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
