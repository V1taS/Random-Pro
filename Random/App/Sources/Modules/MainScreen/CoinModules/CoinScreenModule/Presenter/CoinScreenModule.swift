//
//  CoinScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol CoinScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: CoinScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: CoinScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol CoinScreenModuleInput {
  
  /// Возвращает Модель данных
  func returnModel() -> CoinScreenModel?
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Показать список генераций результатов
  /// - Parameter isShow: показать  список генераций результатов
  func listGenerated(isShow: Bool)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CoinScreenModuleOutput? { get set }
}

typealias CoinScreenModule = ViewController & CoinScreenModuleInput

final class CoinScreenViewController: CoinScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: CoinScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: CoinScreenViewProtocol
  private let interactor: CoinScreenInteractorInput
  private let factory: CoinScreenFactoryInput
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
  init(moduleView: CoinScreenViewProtocol,
       interactor: CoinScreenInteractorInput,
       factory: CoinScreenFactoryInput) {
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
    
    let listResult = interactor.returnModel()?.listResult ?? []
    copyButton.isEnabled = !listResult.isEmpty
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    interactor.updateStyle()
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
    moduleView.cleanButtonAction()
  }
  
  func returnModel() -> CoinScreenModel? {
    interactor.returnModel()
  }
  
  func listGenerated(isShow: Bool) {
    moduleView.listGenerated(isShow: isShow)
  }
}

// MARK: - CoinScreenViewOutput

extension CoinScreenViewController: CoinScreenViewOutput {
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
  
  func saveData(model: CoinScreenModel) {
    interactor.saveData(model: model)
  }
  
  func playHapticFeedbackAction() {
    interactor.playHapticFeedback()
  }
  
  func resultLabelAction() {
    guard let result = interactor.returnModel()?.result,
          result != Appearance().defaultResult else {
      return
    }
    moduleOutput?.resultLabelAction(text: result)
  }
}

// MARK: - CoinScreenInteractorOutput

extension CoinScreenViewController: CoinScreenInteractorOutput {
  func cleanButtonWasSelected(model: CoinScreenModel) {
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: CoinScreenModel) {
    factory.reverseListResultFrom(model: model)
    let listResult = interactor.returnModel()?.listResult ?? []
    copyButton.isEnabled = !listResult.isEmpty
  }
}

// MARK: - CoinScreenFactoryOutput

extension CoinScreenViewController: CoinScreenFactoryOutput {
  func didReverseListResult(model: CoinScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Private

private extension CoinScreenViewController {
  func setNavigationBar() {
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
    guard let model = interactor.returnModel() else { return }
    moduleOutput?.resultLabelAction(text: model.result)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingsButtonAction() {
    guard let model = interactor.returnModel() else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension CoinScreenViewController {
  struct Appearance {
    let title =  RandomStrings.Localizable.eagleOrTail
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
    let defaultResult = "?"
  }
}
