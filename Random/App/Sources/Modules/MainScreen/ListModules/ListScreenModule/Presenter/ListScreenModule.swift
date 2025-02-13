//
//  ListScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ListScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter players: список игроков
  func settingButtonAction()
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String?)
  
  /// Была получена ошибка
  func didReceiveError()
  
  /// Была получена ошибка об отсутствии элементов
  func didReceiveIsEmptyError()
  
  /// Закончился диапазон уникальных элементов
  func didReceiveRangeUniqueItemsError()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ListScreenModuleInput {
  
  /// Возвращает текущей модели
  func returnCurrentModel() -> ListScreenModel
  
  /// Обновить контент
  ///  - Parameter models: Модельки с текстами
  func updateContentWith(models: [ListScreenModel.Section])
  
  /// Обновить контент
  ///  - Parameter value: Без повторений
  func updateWithoutRepetition(_ value: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ListScreenModuleOutput? { get set }
}

/// Псевдоним протокола ViewController & ListScreenModuleInput
typealias ListScreenModule = ViewController & ListScreenModuleInput

final class ListScreenViewController: ListScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: ListScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: ListScreenViewProtocol
  private let interactor: ListScreenInteractorInput
  private let factory: ListScreenFactoryInput
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
  init(moduleView: ListScreenViewProtocol,
       interactor: ListScreenInteractorInput,
       factory: ListScreenFactoryInput) {
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
    
    setupNavigationBar()
    interactor.getContent()
    copyButton.isEnabled = !interactor.returnCurrentModel().generetionItems.isEmpty

    Metrics.shared.track(event: .listScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .listScreenClose)
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> ListScreenModel {
    interactor.returnCurrentModel()
  }
  
  func updateContentWith(models: [ListScreenModel.Section]) {
    interactor.updateContentWith(models: models)
  }
  
  func updateWithoutRepetition(_ value: Bool) {
    interactor.updateWithoutRepetition(value)
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
}

// MARK: - ListScreenViewOutput

extension ListScreenViewController: ListScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
    Metrics.shared.track(event: .listScreenCloseButtonGenerate)
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
    Metrics.shared.track(event: .listScreenCloseButtonResultLabelCopied)
  }
}

// MARK: - ListScreenInteractorOutput

extension ListScreenViewController: ListScreenInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceiveIsEmptyError() {
    moduleOutput?.didReceiveIsEmptyError()
  }
  
  func didReceiveRangeUniqueItemsError() {
    moduleOutput?.didReceiveRangeUniqueItemsError()
  }
  
  func didReceiveError() {
    moduleOutput?.didReceiveError()
  }
  
  func didReceiveModel(_ model: ListScreenModel) {
    moduleView.updateContentWith(text: model.result)
    copyButton.isEnabled = !interactor.returnCurrentModel().generetionItems.isEmpty
  }
}

// MARK: - ListScreenFactoryOutput

extension ListScreenViewController: ListScreenFactoryOutput {}

// MARK: - Private

private extension ListScreenViewController {
  func setupNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingsButtonAction)),
      copyButton
    ]
  }
  
  @objc
  func copyButtonAction() {
    moduleOutput?.resultCopied(text: interactor.returnCurrentModel().result)
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .listScreenCloseButtonResultNavigationCopied)
  }
  
  @objc
  func settingsButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .listScreenCloseButtonSetting)
  }
}
// MARK: - Appearance

private extension ListScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = RandomStrings.Localizable.list
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
