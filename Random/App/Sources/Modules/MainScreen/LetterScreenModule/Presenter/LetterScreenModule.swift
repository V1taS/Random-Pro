//
//  LetterScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol LetterScreenModuleOutput: AnyObject {
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: LetterScreenModel)
  
  /// Диапазон чисел закончился
  func didReceiveRangeEnded()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: LetterScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol LetterScreenModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: LetterScreenModuleOutput? { get set }
}

typealias LetterScreenModule = ViewController & LetterScreenModuleInput

final class LetterScreenViewController: LetterScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: LetterScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: LetterScreenViewProtocol
  private let interactor: LetterScreenInteractorInput
  private let factory: LetterScreenFactoryInput
  private var cacheModel: LetterScreenModel?
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
  init(moduleView: LetterScreenViewProtocol,
       interactor: LetterScreenInteractorInput,
       factory: LetterScreenFactoryInput) {
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
    interactor.getContent()
    copyButton.isEnabled = !interactor.returnListResult().isEmpty

    Metrics.shared.track(event: .letterScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .letterScreenClose)
  }
  
  // MARK: - Internal func
  
  func withoutRepetitionAction(isOn: Bool) {
    interactor.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnListResult() -> [String] {
    interactor.returnListResult()
  }
}

// MARK: - LetterScreenViewOutput

extension LetterScreenViewController: LetterScreenViewOutput {
  func generateEngButtonAction() {
    interactor.generateContentEngLetter()
    Metrics.shared.track(event: .letterScreenButtonGenerateEng)
  }
  
  func generateRusButtonAction() {
    interactor.generateContentRusLetter()
    Metrics.shared.track(event: .letterScreenButtonGenerateRus)
  }
  
  func resultLabelAction() {
    guard let result = cacheModel?.result, result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultLabelAction(text: result)
    Metrics.shared.track(event: .letterScreenButtonResultLabelCopied)
  }
}

// MARK: - LetterScreenInteractorOutput

extension LetterScreenViewController: LetterScreenInteractorOutput {
  func cleanButtonWasSelected(model: LetterScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: LetterScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
  
  func didReceiveRangeEnded() {
    moduleOutput?.didReceiveRangeEnded()
  }
}

// MARK: - LetterScreenFactoryOutput

extension LetterScreenViewController: LetterScreenFactoryOutput {
  func didReverseListResult(model: LetterScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Private

private extension LetterScreenViewController {
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
    guard let model = cacheModel else { return }
    moduleOutput?.resultLabelAction(text: model.result)
    impactFeedback.impactOccurred()

    Metrics.shared.track(event: .letterScreenButtonResultNavigationCopied)
  }
  
  @objc
  func settingButtonAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .letterScreenButtonSetting)
  }
}

// MARK: - Appearance

private extension LetterScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.letter
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
