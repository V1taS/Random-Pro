//
//  PasswordScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol PasswordScreenModuleOutput: AnyObject {
  
  /// Была получена ошибка
  func didReciveError()
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: PasswordScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol PasswordScreenModuleInput {
  
  /// Запросить текущую модель
  func returnCurrentModel() -> PasswordScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: PasswordScreenModuleOutput? { get set }
}

typealias PasswordScreenModule = UIViewController & PasswordScreenModuleInput

final class PasswordScreenViewController: PasswordScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: PasswordScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: PasswordScreenViewProtocol
  private let interactor: PasswordScreenInteractorInput
  private let factory: PasswordScreenFactoryInput
  private lazy var copyButton = UIBarButtonItem(image: Appearance().copyButtonIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(copyButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
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
  
  // MARK: - Internal func
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    interactor.getContent()
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
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
  func generateButtonAction(passwordLength: String?) {
    interactor.generateButtonAction(passwordLength: passwordLength)
  }
  
  func passwordLengthDidChange(_ text: String?) {
    interactor.passwordLengthDidChange(text)
  }
  
  func uppercaseSwitchAction(status: Bool) {
    interactor.uppercaseSwitchAction(status: status)
  }
  
  func lowercaseSwitchAction(status: Bool) {
    interactor.lowercaseSwitchAction(status: status)
  }
  
  func numbersSwitchAction(status: Bool) {
    interactor.numbersSwitchAction(status: status)
  }
  
  func symbolsSwitchAction(status: Bool) {
    interactor.symbolsSwitchAction(status: status)
  }
}

// MARK: - PasswordScreenFactoryOutput

extension PasswordScreenViewController: PasswordScreenFactoryOutput {}

// MARK: - PasswordScreenInteractorOutput

extension PasswordScreenViewController: PasswordScreenInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReciveError() {
    moduleOutput?.didReciveError()
  }
  
  func didRecive(model: PasswordScreenModel) {
    moduleView.setPasswordLength(model.passwordLength)
    moduleView.set(resultClassic: model.result,
                   switchState: model.switchState)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  func didRecivePasswordLength(text: String?) {
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
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
  }
}

// MARK: - Appearance

private extension PasswordScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Пароли", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
  }
}
