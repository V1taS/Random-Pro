//
//  YesNoScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

protocol YesNoScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: YesNoScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: YesNoScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
  
  /// Модуль был закрыт
  func moduleClosed()
}

protocol YesNoScreenModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: YesNoScreenModuleOutput? { get set }
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

typealias YesNoScreenModule = ViewController & YesNoScreenModuleInput

final class YesNoScreenViewController: YesNoScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: YesNoScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: YesNoScreenViewProtocol
  private let interactor: YesNoScreenInteractorInput
  private let factory: YesNoScreenFactoryInput
  private var cacheModel: YesNoScreenModel?
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
  init(moduleView: YesNoScreenViewProtocol,
       interactor: YesNoScreenInteractorInput,
       factory: YesNoScreenFactoryInput) {
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
    setupNavBar()
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Initernal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnListResult() -> [String] {
    interactor.returnListResult()
  }
}

// MARK: - YesNoScreenViewOutput

extension YesNoScreenViewController: YesNoScreenViewOutput {
  func generateButtonAction() {
    interactor.generateContent()
  }
  
  func resultLabelAction() {
    guard let result = cacheModel?.result, result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultLabelAction(text: result)
  }
}

// MARK: - YesNoScreenInteractorOutput

extension YesNoScreenViewController: YesNoScreenInteractorOutput {
  func cleanButtonWasSelected(model: YesNoScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: YesNoScreenModel) {
    cacheModel = model
    moduleView.set(result: model.result)
    factory.reverse(listResult: model.listResult)
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
}

// MARK: - YesNoScreenFactoryOutput

extension YesNoScreenViewController: YesNoScreenFactoryOutput {
  func didReverse(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - Private

private extension YesNoScreenViewController {
  func setupNavBar() {
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
  }
  
  @objc
  func settingButtonAction() {
    guard let cacheModel = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: cacheModel)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension YesNoScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.yesOrNo
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
