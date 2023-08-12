//
//  GoodDeedsScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 02.06.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol GoodDeedsScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: GoodDeedsScreenModel)
  
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
protocol GoodDeedsScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> GoodDeedsScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: GoodDeedsScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: GoodDeedsScreenModuleOutput? { get set }
}

/// Готовый модуль `GoodDeedsScreenModule`
typealias GoodDeedsScreenModule = ViewController & GoodDeedsScreenModuleInput

/// Презентер
final class GoodDeedsScreenViewController: GoodDeedsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: GoodDeedsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: GoodDeedsScreenInteractorInput
  private let moduleView: GoodDeedsScreenViewProtocol
  private let factory: GoodDeedsScreenFactoryInput
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
  init(moduleView: GoodDeedsScreenViewProtocol,
       interactor: GoodDeedsScreenInteractorInput,
       factory: GoodDeedsScreenFactoryInput) {
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
  
  func returnCurrentModel() -> GoodDeedsScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setNewLanguage(language: GoodDeedsScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - GoodDeedsScreenViewOutput

extension GoodDeedsScreenViewController: GoodDeedsScreenViewOutput {
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

// MARK: - GoodDeedsScreenInteractorOutput

extension GoodDeedsScreenViewController: GoodDeedsScreenInteractorOutput {
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

// MARK: - GoodDeedsScreenFactoryOutput

extension GoodDeedsScreenViewController: GoodDeedsScreenFactoryOutput {}

// MARK: - Private

private extension GoodDeedsScreenViewController {
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

private extension GoodDeedsScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.goodDeeds
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
