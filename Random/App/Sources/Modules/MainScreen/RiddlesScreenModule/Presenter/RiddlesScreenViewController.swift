//
//  RiddlesScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 03.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol RiddlesScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: RiddlesScreenModel)
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Кнопка с ответом была нажата
  /// - Parameter text: Ответ по загадке
  func infoButtonAction(text: String)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol RiddlesScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> RiddlesScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: RiddlesScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: RiddlesScreenModuleOutput? { get set }
}

/// Готовый модуль `RiddlesScreenModule`
typealias RiddlesScreenModule = ViewController & RiddlesScreenModuleInput

/// Презентер
final class RiddlesScreenViewController: RiddlesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: RiddlesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: RiddlesScreenInteractorInput
  private let moduleView: RiddlesScreenViewProtocol
  private let factory: RiddlesScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private lazy var copyButton = UIBarButtonItem(image: Appearance().copyButtonIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(copyButtonAction))
  private lazy var infoButton = UIBarButtonItem(image: Appearance().infoButtonIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(infoButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: RiddlesScreenViewProtocol,
       interactor: RiddlesScreenInteractorInput,
       factory: RiddlesScreenFactoryInput) {
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
    interactor.getContent(type: nil)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
    infoButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> RiddlesScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setNewLanguage(language: RiddlesScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - RiddlesScreenViewOutput

extension RiddlesScreenViewController: RiddlesScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result.question != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result.question)
  }
  
  func segmentedControlValueDidChange(type: RiddlesScreenModel.DifficultType) {
    interactor.segmentedControlValueDidChange(type: type)
  }
}

// MARK: - RiddlesScreenInteractorOutput

extension RiddlesScreenViewController: RiddlesScreenInteractorOutput {
  func didReceive(riddles: RiddlesScreenModel.Riddles, type: RiddlesScreenModel.DifficultType) {
    moduleView.stopLoader()
    moduleView.set(riddles: riddles, type: type)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
    infoButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  func somethingWentWrong() {
    moduleView.stopLoader()
    moduleOutput?.somethingWentWrong()
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
}

// MARK: - RiddlesScreenFactoryOutput

extension RiddlesScreenViewController: RiddlesScreenFactoryOutput {}

// MARK: - Private

private extension RiddlesScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      copyButton,
      infoButton
    ]
  }
  
  @objc
  func infoButtonAction() {
    moduleOutput?.infoButtonAction(text: interactor.returnCurrentModel().result.answer)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func copyButtonAction() {
    moduleOutput?.resultCopied(text: interactor.returnCurrentModel().result.question)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension RiddlesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.riddles
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let infoButtonIcon = UIImage(systemName: "info.circle")
    let defaultResult = "?"
  }
}
