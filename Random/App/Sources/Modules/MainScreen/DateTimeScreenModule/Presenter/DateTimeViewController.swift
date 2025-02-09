//
//  DateTimeViewController.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol DateTimeModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: DateTimeScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: DateTimeScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter model: Результат генерации
  func resultLabelAction(model: DateTimeScreenModel)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol DateTimeModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: DateTimeModuleOutput? { get set }
}

typealias DateTimeModule = ViewController & DateTimeModuleInput

final class DateTimeViewController: DateTimeModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: DateTimeModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: DateTimeViewProtocol
  private let interactor: DateTimeInteractorInput
  private let factory: DateTimeFactoryInput
  private var cacheModel: DateTimeScreenModel?
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
  init(moduleView: DateTimeViewProtocol,
       interactor: DateTimeInteractorInput,
       factory: DateTimeFactoryInput) {
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
    
    interactor.getContent()
    setNavigationBar()
    copyButton.isEnabled = !interactor.returnListResult().isEmpty

    Metrics.shared.track(event: .dateTimeScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .dateTimeScreenClose)
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnListResult() -> [String] {
    interactor.returnListResult()
  }
}

// MARK: - DateTimeViewOutput

extension DateTimeViewController: DateTimeViewOutput {
  func resultLabelAction() {
    guard let model = cacheModel, model.result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultLabelAction(model: model)
    Metrics.shared.track(event: .dateTimeScreenButtonResultLabelCopied)
  }
  
  func generateButtonDayAction() {
    interactor.generateContentDay()
    Metrics.shared.track(event: .dateTimeScreenButtonGenerateDay)
  }
  
  func generateButtonDateAction() {
    interactor.generateContentDate()
    Metrics.shared.track(event: .dateTimeScreenButtonGenerateDate)
  }
  
  func generateButtonTimeAction() {
    interactor.generateContentTime()
    Metrics.shared.track(event: .dateTimeScreenButtonGenerateTime)
  }
  
  func generateButtonMonthAction() {
    interactor.generateContentMonth()
    Metrics.shared.track(event: .dateTimeScreenButtonGenerateMonth)
  }
}

// MARK: - DateTimeInteractorOutput

extension DateTimeViewController: DateTimeInteractorOutput {
  func cleanButtonWasSelected(model: DateTimeScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: DateTimeScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
}

// MARK: - DateTimeFactoryOutput

extension DateTimeViewController: DateTimeFactoryOutput {
  func didReverseListResult(model: DateTimeScreenModel) {
    moduleView.updateContentWith(model: model)
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
}

// MARK: - Private

private extension DateTimeViewController {
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
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.resultLabelAction(model: model)
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .dateTimeScreenButtonResultNavigationCopied)
  }
  
  @objc
  func settingButtonAction() {
    guard let cacheModel = cacheModel else { return }
    moduleOutput?.settingButtonAction(model: cacheModel)
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .dateTimeScreenButtonSetting)
  }
}

// MARK: - Appearance

private extension DateTimeViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.dateAndTime
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
