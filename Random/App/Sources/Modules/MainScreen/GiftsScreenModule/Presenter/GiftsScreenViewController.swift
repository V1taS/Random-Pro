//
//  GiftsScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 05.06.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol GiftsScreenModuleOutput: AnyObject {

  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: GiftsScreenModel)

  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol GiftsScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: GiftsScreenModuleOutput? { get set }

  /// Запросить текущую модель
  func returnCurrentModel() -> GiftsScreenModel

  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()

  /// Установить новый язык
  func setNewLanguage(language: GiftsScreenModel.Language)
}

/// Готовый модуль `GiftsScreenModule`
typealias GiftsScreenModule = UIViewController & GiftsScreenModuleInput

/// Презентер
final class GiftsScreenViewController: GiftsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: GiftsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: GiftsScreenInteractorInput
  private let moduleView: GiftsScreenViewProtocol
  private let factory: GiftsScreenFactoryInput
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
  init(moduleView: GiftsScreenViewProtocol,
       interactor: GiftsScreenInteractorInput,
       factory: GiftsScreenFactoryInput) {
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

  // MARK: - Internal func

  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }

  func returnCurrentModel() -> GiftsScreenModel {
    interactor.returnCurrentModel()
  }

  func setNewLanguage(language: GiftsScreenModel.Language) {
    interactor.setNewLanguage(language: language)
  }
}

// MARK: - GiftsScreenViewOutput

extension GiftsScreenViewController: GiftsScreenViewOutput {
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

  func segmentedControlValueDidChange(type: GiftsScreenModel.Gender) {
    interactor.segmentedControlValueDidChange(type: type)
  }
}

// MARK: - GiftsScreenInteractorOutput

extension GiftsScreenViewController: GiftsScreenInteractorOutput {
  func didReceive(text: String?, gender: GiftsScreenModel.Gender) {
    moduleView.stopLoader()
    moduleView.set(result: text, gender: gender)
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

// MARK: - GiftsScreenFactoryOutput

extension GiftsScreenViewController: GiftsScreenFactoryOutput {}

// MARK: - Private

private extension GiftsScreenViewController {
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

private extension GiftsScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.gifts
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
