//
//  PasswordScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PasswordScreenModuleOutput: AnyObject {
  
  /// Была получена ошибка из-за слишком короткой длины пароля
  func didReceiveErrorWithCountOfCharacters()
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: PasswordScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol PasswordScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> PasswordScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: PasswordScreenModuleOutput? { get set }
}

typealias PasswordScreenModule = ViewController & PasswordScreenModuleInput

final class PasswordScreenViewController: PasswordScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: PasswordScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: PasswordScreenViewProtocol
  private let interactor: PasswordScreenInteractorInput
  private let factory: PasswordScreenFactoryInput
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
  init(moduleView: PasswordScreenViewProtocol,
       interactor: PasswordScreenInteractorInput,
       factory: PasswordScreenFactoryInput) {
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
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty

    Metrics.shared.track(event: .passwordScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .passwordScreenClose)
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> PasswordScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
}

// MARK: - PasswordScreenViewOutput

extension PasswordScreenViewController: PasswordScreenViewOutput {
  func calculateCrackTime(password: String) {
    interactor.calculateCrackTime(password: password)
  }
  
  func generateButtonAction(passwordLength: String?) {
    interactor.generateButtonAction(passwordLength: passwordLength)
    Metrics.shared.track(event: .passwordScreenButtonGenerate)
  }
  
  func passwordLengthDidChange(_ text: String?) {
    interactor.passwordLengthDidChange(text)
  }
  
  func uppercaseSwitchAction(status: Bool) {
    interactor.uppercaseSwitchAction(status: status)
    Metrics.shared.track(event: .passwordScreenUppercaseSwitchAction)
  }
  
  func lowercaseSwitchAction(status: Bool) {
    interactor.lowercaseSwitchAction(status: status)
    Metrics.shared.track(event: .passwordScreenLowercaseSwitchAction)
  }
  
  func numbersSwitchAction(status: Bool) {
    interactor.numbersSwitchAction(status: status)
    Metrics.shared.track(event: .passwordScreenNumbersSwitchAction)
  }
  
  func symbolsSwitchAction(status: Bool) {
    interactor.symbolsSwitchAction(status: status)
    Metrics.shared.track(event: .passwordScreenSymbolsSwitchAction)
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
    Metrics.shared.track(event: .passwordScreenButtonResultLabelCopied)
  }
}

// MARK: - PasswordScreenFactoryOutput

extension PasswordScreenViewController: PasswordScreenFactoryOutput {}

// MARK: - PasswordScreenInteractorOutput

extension PasswordScreenViewController: PasswordScreenInteractorOutput {
  func didReceiveCrackTime(text: String, strengthValue: Float) {
    moduleView.updateCrackTime(text: text, strengthValue: strengthValue)
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceiveErrorWithCountOfCharacters() {
    moduleOutput?.didReceiveErrorWithCountOfCharacters()
  }
  
  func didReceive(model: PasswordScreenModel) {
    moduleView.setPasswordLength(model.passwordLength)
    moduleView.set(resultClassic: model.result,
                   switchState: model.switchState)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  func didReceivePasswordLength(text: String?) {
    moduleView.setPasswordLength(text)
  }
}

// MARK: - Private

private extension PasswordScreenViewController {
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
    Metrics.shared.track(event: .passwordScreenButtonResultNavigationCopied)
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .passwordScreenButtonSetting)
  }
}

// MARK: - Appearance

private extension PasswordScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.passwords
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
