//
//  LetterScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

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

typealias LetterScreenModule = UIViewController & LetterScreenModuleInput

final class LetterScreenViewController: LetterScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: LetterScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: LetterScreenViewProtocol
  private let interactor: LetterScreenInteractorInput
  private let factory: LetterScreenFactoryInput
  private var cacheModel: LetterScreenModel?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
  }
  
  func generateRusButtonAction() {
    interactor.generateContentRusLetter()
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc
  func settingButtonAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension LetterScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Буква", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
