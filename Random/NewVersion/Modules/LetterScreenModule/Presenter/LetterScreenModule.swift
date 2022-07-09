//
//  LetterScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LetterScreenModuleOutput: AnyObject {
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: LetterScreenModel)
  
  /// Диапазон чисел закончился
  func didReciveRangeEnded()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: LetterScreenModel)
}

protocol LetterScreenModuleInput: AnyObject {
  
  /// Событие, без повторений
  /// - Parameter isOn: Без повторений `true` или `false`
  func withoutRepetitionAction(isOn: Bool)
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
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
  
  // MARK: - Initialization
  
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
  
  // MARK: - Internal func
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar()
    interactor.getContent()
  }
  
  func withoutRepetitionAction(isOn: Bool) {
    interactor.withoutRepetitionAction(isOn: isOn)
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  // MARK: - Private func
  
  private func navigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc
  private func settingButtonAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
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
  
  func didRecive(model: LetterScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
  
  func didReciveRangeEnded() {
    moduleOutput?.didReciveRangeEnded()
  }
}

// MARK: - LetterScreenFactoryOutput

extension LetterScreenViewController: LetterScreenFactoryOutput {
  func didReverseListResult(model: LetterScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Appearance

private extension LetterScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Буква", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
