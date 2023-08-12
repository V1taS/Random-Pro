//
//  CongratulationsScreenViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 28.05.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol CongratulationsScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: CongratulationsScreenModel)
  
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
protocol CongratulationsScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CongratulationsScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Установить новый язык
  func setNewLanguage(language: CongratulationsScreenModel.Language)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CongratulationsScreenModuleOutput? { get set }
}

/// Готовый модуль `CongratulationsScreenModule`
typealias CongratulationsScreenModule = ViewController & CongratulationsScreenModuleInput

/// Презентер
final class CongratulationsScreenViewController: CongratulationsScreenModule {

  // MARK: - Internal properties
  
  weak var moduleOutput: CongratulationsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: CongratulationsScreenInteractorInput
  private let moduleView: CongratulationsScreenViewProtocol
  private let factory: CongratulationsScreenFactoryInput
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
  init(moduleView: CongratulationsScreenViewProtocol,
       interactor: CongratulationsScreenInteractorInput,
       factory: CongratulationsScreenFactoryInput) {
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
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> CongratulationsScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setNewLanguage(language: CongratulationsScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - CongratulationsScreenViewOutput

extension CongratulationsScreenViewController: CongratulationsScreenViewOutput {
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
  
  func segmentedControlValueDidChange(type: CongratulationsScreenModel.CongratulationsType) {
    interactor.segmentedControlValueDidChange(type: type)
  }
}

// MARK: - CongratulationsScreenInteractorOutput

extension CongratulationsScreenViewController: CongratulationsScreenInteractorOutput {
  func didReceive(name: String?, type: CongratulationsScreenModel.CongratulationsType) {
    moduleView.stopLoader()
    moduleView.set(result: name, type: type)
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

// MARK: - CongratulationsScreenFactoryOutput

extension CongratulationsScreenViewController: CongratulationsScreenFactoryOutput {}

// MARK: - Private

private extension CongratulationsScreenViewController {
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

private extension CongratulationsScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.congratulations
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
