//
//  NickNameScreenModule.swift
//  Random
//
//  Created by Tatyana Sosina on 15.05.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol NickNameScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: NickNameScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol NickNameScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> NickNameScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: NickNameScreenModuleOutput? { get set }
}

/// Готовый модуль `NickNameScreenModule`
typealias NickNameScreenModule = ViewController & NickNameScreenModuleInput

/// Презентер
final class NickNameScreenViewController: NickNameScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: NickNameScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: NickNameScreenInteractorInput
  private let moduleView: NickNameScreenViewProtocol
  private let factory: NickNameScreenFactoryInput
  private var cacheModel: NickNameScreenModel?
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
  init(moduleView: NickNameScreenViewProtocol,
       interactor: NickNameScreenInteractorInput,
       factory: NickNameScreenFactoryInput) {
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
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnCurrentModel() -> NickNameScreenModel {
    interactor.returnCurrentModel()
  }
}

// MARK: - NickNameScreenViewOutput

extension NickNameScreenViewController: NickNameScreenViewOutput {
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
  }
  
  func generateShortButtonAction() {
    interactor.generateShortButtonAction()
  }
  
  func generatePopularButtonAction() {
    interactor.generatePopularButtonAction()
  }
}

// MARK: - NickNameScreenInteractorOutput

extension NickNameScreenViewController: NickNameScreenInteractorOutput {
  func somethingWentWrong() {
    moduleView.stopLoader()
    moduleOutput?.somethingWentWrong()
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceive(nick: String?) {
    moduleView.stopLoader()
    moduleView.set(result: nick)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
}

// MARK: - NickNameScreenFactoryOutput

extension NickNameScreenViewController: NickNameScreenFactoryOutput {}

// MARK: - Private

private extension NickNameScreenViewController {
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

private extension NickNameScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.nickname
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
