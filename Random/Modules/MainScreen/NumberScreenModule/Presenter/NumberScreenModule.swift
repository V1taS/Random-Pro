//
//  NumberScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol NumberScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: NumberScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: NumberScreenModel)
  
  /// Диапазон чисел закончился
  func didReceiveRangeEnded()
  
  /// Было нажатие на результат генерации
  ///  - Parameter text: Результат генерации
  func resultLabelAction(text: String?)
  
  /// Неправильный диапазон чисел
  func didReceiveRangeError()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol NumberScreenModuleInput: AnyObject {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: NumberScreenModuleOutput? { get set }
}

typealias NumberScreenModule = UIViewController & NumberScreenModuleInput

final class NumberScreenViewController: NumberScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: NumberScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: UIView & NumberScreenViewInput
  private let interactor: NumberScreenInteractorInput
  private let factory: NumberScreenFactoryInput
  private var cacheModel: NumberScreenModel?
  private lazy var copyButton = UIBarButtonItem(image: Appearance().copyButtonIcon,
                                                style: .plain,
                                                target: self,
                                                action: #selector(copyButtonAction))
  
  // MARK: - Initialization
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: UIView & NumberScreenViewInput,
       interactor: NumberScreenInteractorInput,
       factory: NumberScreenFactoryInput) {
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
    setupNavBar()
    interactor.getContent(withWithoutRepetition: false)
    copyButton.isEnabled = !interactor.returnModel().listResult.isEmpty
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

// MARK: - NumberScreenViewOutput

extension NumberScreenViewController: NumberScreenViewOutput {
  func rangeStartDidChange(_ text: String?) {
    interactor.rangeStartDidChange(text)
  }
  
  func rangeEndDidChange(_ text: String?) {
    interactor.rangeEndDidChange(text)
  }
  
  func generateButtonAction(rangeStartValue: String?, rangeEndValue: String?) {
    interactor.generateContent(firstTextFieldValue: rangeStartValue,
                               secondTextFieldValue: rangeEndValue)
  }
}

// MARK: - NumberScreenFactoryOutput

extension NumberScreenViewController: NumberScreenFactoryOutput {
  func didClearGeneration(text: String?) {
    moduleOutput?.resultLabelAction(text: text)
  }
  
  func didReverse(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - NumberScreenInteractorOutput

extension NumberScreenViewController: NumberScreenInteractorOutput {
  func didReceiveRangeError() {
    moduleOutput?.didReceiveRangeError()
  }
  
  func didReceiveRangeEnded() {
    moduleOutput?.didReceiveRangeEnded()
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: NumberScreenModel) {
    cacheModel = model
    factory.reverse(listResult: model.listResult)
    moduleView.set(result: model.result)
    moduleView.setRangeStart(model.rangeStartValue)
    moduleView.setRangeEnd(model.rangeEndValue)
    
    copyButton.isEnabled = !interactor.returnModel().listResult.isEmpty
  }
  
  func didReceiveRangeStart(text: String?) {
    moduleView.setRangeStart(text)
  }
  
  func didReceiveRangeEnd(text: String?) {
    moduleView.setRangeEnd(text)
  }
}

// MARK: - Private

private extension NumberScreenViewController {
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
    factory.clearGeneration(text: interactor.returnModel().result)
  }
  
  @objc
  func settingButtonAction() {
    guard let cacheModel = cacheModel else { return }
    moduleOutput?.settingButtonAction(model: cacheModel)
  }
}

// MARK: - Appearance

private extension NumberScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Число", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
  }
}
