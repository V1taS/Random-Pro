//
//  NumberScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: NumberScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: NumberScreenModel)
  
  /// Диапазон чисел закончился
  func didReciveRangeEnded()
}

protocol NumberScreenModuleInput: AnyObject {
  
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
  
  // MARK: - Initialization
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
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
    interactor.getContent()
  }
  
  // MARK: - Internal func
  
  func withoutRepetitionAction(isOn: Bool) {
    interactor.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  // MARK: - Private func
  
  private func setupNavBar() {
    let appearance = Appearance()
    
    navigationController?.navigationBar.prefersLargeTitles = false
    title = appearance.title
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc private func settingButtonAction() {
    guard let cacheModel = cacheModel else { return }
    moduleOutput?.settingButtonAction(model: cacheModel)
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
  func didReverse(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - NumberScreenInteractorOutput

extension NumberScreenViewController: NumberScreenInteractorOutput {
  func didReciveRangeEnded() {
    moduleOutput?.didReciveRangeEnded()
  }
  
  func cleanButtonWasSelected(model: NumberScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didRecive(model: NumberScreenModel) {
    cacheModel = model
    factory.reverse(listResult: model.listResult)
    moduleView.set(result: model.result)
    moduleView.set(rangeStartValue: model.rangeStartValue,
                   rangeEndValue: model.rangeEndValue)
  }
  
  func didReciveRangeStart(text: String?) {
    moduleView.setRangeStart(text)
  }
  
  func didReciveRangeEnd(text: String?) {
    moduleView.setRangeEnd(text)
  }
}

// MARK: - Appearance

private extension NumberScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Число", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
