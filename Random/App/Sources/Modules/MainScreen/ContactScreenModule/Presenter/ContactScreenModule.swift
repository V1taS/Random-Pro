//
//  ContactScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ContactScreenModuleOutput: AnyObject {
  
  /// Кнопка настройки была нажата
  func settingButtonAction()
  
  /// Была получена ошибка
  func didReceiveError()
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ContactScreenModuleInput {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> ContactScreenModel
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ContactScreenModuleOutput? { get set }
}

/// Псевдоним протокола ViewController & ContactScreenModuleInput
typealias ContactScreenModule = ViewController & ContactScreenModuleInput

final class ContactScreenViewController: ContactScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: ContactScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: ContactScreenViewProtocol
  private let interactor: ContactScreenInteractorInput
  private let factory: ContactScreenFactoryInput
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
  init(moduleView: ContactScreenViewProtocol,
       interactor: ContactScreenInteractorInput,
       factory: ContactScreenFactoryInput) {
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
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty

    Metrics.shared.track(event: .contactScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .contactScreenClose)
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> ContactScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
}

// MARK: - ContactScreenViewOutput

extension ContactScreenViewController: ContactScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
    Metrics.shared.track(event: .contactScreenButtonGenerate)
  }
  
  func resultLabelAction() {
    let result = interactor.returnCurrentModel().result
    guard result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultCopied(text: result)
    Metrics.shared.track(event: .contactScreenButtonResultLabelCopied)
  }
}

// MARK: - ContactScreenInteractorOutput

extension ContactScreenViewController: ContactScreenInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceiveError() {
    moduleOutput?.didReceiveError()
  }
  
  func didReceive(model: ContactScreenModel) {
    moduleView.setResult(model.result)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
}

// MARK: - ContactScreenFactoryOutput

extension ContactScreenViewController: ContactScreenFactoryOutput {}

// MARK: - Private

private extension ContactScreenViewController {
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

    Metrics.shared.track(event: .contactScreenButtonResultNavigationCopied)
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .contactScreenButtonSetting)
  }
}

// MARK: - Appearance

extension ContactScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = RandomStrings.Localizable.contacts
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
