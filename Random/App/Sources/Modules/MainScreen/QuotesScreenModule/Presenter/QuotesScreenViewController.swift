//
//  QuotesScreenViewController.swift
//  Random
//
//  Created by Mikhail Kolkov on 6/8/23.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol QuotesScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: QuoteScreenModel)
  
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
protocol QuotesScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> QuoteScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: QuoteScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: QuotesScreenModuleOutput? { get set }
}

/// Готовый модуль `QuotesScreenModule`
typealias QuotesScreenModule = ViewController & QuotesScreenModuleInput

/// Презентер
final class QuotesScreenViewController: QuotesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: QuotesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: QuotesScreenInteractorInput
  private let moduleView: QuotesScreenViewProtocol
  private let factory: QuotesScreenFactoryInput
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
  init(moduleView: QuotesScreenViewProtocol,
       interactor: QuotesScreenInteractorInput,
       factory: QuotesScreenFactoryInput) {
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
  
  func returnCurrentModel() -> QuoteScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setNewLanguage(language: QuoteScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - QuotesScreenViewOutput

extension QuotesScreenViewController: QuotesScreenViewOutput {
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

// MARK: - QuotesScreenInteractorOutput

extension QuotesScreenViewController: QuotesScreenInteractorOutput {
  func didReceive(quote: String?) {
    moduleView.stopLoader()
    moduleView.set(result: quote)
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

// MARK: - QuotesScreenFactoryOutput

extension QuotesScreenViewController: QuotesScreenFactoryOutput {}

// MARK: - Private

private extension QuotesScreenViewController {
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

private extension QuotesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.quotes
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
