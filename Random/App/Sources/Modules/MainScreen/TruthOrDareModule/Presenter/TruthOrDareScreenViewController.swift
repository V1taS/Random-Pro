//
//  TruthOrDareScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 09.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol TruthOrDareScreenModuleOutput: AnyObject {

  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: TruthOrDareScreenModel)

  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol TruthOrDareScreenModuleInput {

  /// Запросить текущую модель
  func returnCurrentModel() -> TruthOrDareScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Установить новый язык
  func setNewLanguage(language: TruthOrDareScreenModel.Language)

  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: TruthOrDareScreenModuleOutput? { get set }
}

/// Готовый модуль `TruthOrDareScreenModule`
typealias TruthOrDareScreenModule = UIViewController & TruthOrDareScreenModuleInput

/// Презентер
final class TruthOrDareScreenViewController: TruthOrDareScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: TruthOrDareScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: TruthOrDareScreenInteractorInput
  private let moduleView: TruthOrDareScreenViewProtocol
  private let factory: TruthOrDareScreenFactoryInput
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
  init(moduleView: TruthOrDareScreenViewProtocol,
       interactor: TruthOrDareScreenInteractorInput,
       factory: TruthOrDareScreenFactoryInput) {
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

  // MARK: - Internal func

  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }

  func returnCurrentModel() -> TruthOrDareScreenModel {
    interactor.returnCurrentModel()
  }

  func setNewLanguage(language: TruthOrDareScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - TruthOrDareScreenViewOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }

  func segmentedControlValueDidChange(type: TruthOrDareScreenModel.TruthOrDareType) {
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

// MARK: - TruthOrDareScreenInteractorOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenInteractorOutput {
  func didReceive(data: String?, type: TruthOrDareScreenModel.TruthOrDareType) {
    moduleView.stopLoader()
    moduleView.set(result: data, type: type)
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

// MARK: - TruthOrDareScreenFactoryOutput

extension TruthOrDareScreenViewController: TruthOrDareScreenFactoryOutput {}

// MARK: - Private

private extension TruthOrDareScreenViewController {
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

private extension TruthOrDareScreenViewController {
  struct Appearance {
    let title = "\(RandomStrings.Localizable.truth) \(RandomStrings.Localizable.or) \(RandomStrings.Localizable.dare)"
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
