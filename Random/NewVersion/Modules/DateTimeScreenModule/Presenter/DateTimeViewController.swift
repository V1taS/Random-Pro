//
//  DateTimeViewController.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol DateTimeModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: DateTimeScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: DateTimeScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter model: Результат генерации
  func resultLabelAction(model: DateTimeScreenModel)
}

protocol DateTimeModuleInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: DateTimeModuleOutput? { get set }
}

typealias DateTimeModule = UIViewController & DateTimeModuleInput

final class DateTimeViewController: DateTimeModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: DateTimeModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: DateTimeViewProtocol
  private let interactor: DateTimeInteractorInput
  private let factory: DateTimeFactoryInput
  private var cacheModel: DateTimeScreenModel?
  
  // MARK: - Initialization
  
  init(moduleView: DateTimeViewProtocol, interactor: DateTimeInteractorInput, factory: DateTimeFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: - Internal func
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    interactor.getContent()
    navigationBar()
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

// MARK: - DateTimeViewOutput

extension DateTimeViewController: DateTimeViewOutput {
  func resultLabelAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.resultLabelAction(model: model)
  }
  
  func generateButtonDayAction() {
    interactor.generateContentDay()
  }
  
  func generateButtonDateAction() {
    interactor.generateContentDate()
  }
  
  func generateButtonTimeAction() {
    interactor.generateContentTime()
  }
  
  func generateButtonMonthAction() {
    interactor.generateContentMonth()
  }
}

// MARK: - DateTimeInteractorOutput

extension DateTimeViewController: DateTimeInteractorOutput {
  func cleanButtonWasSelected(model: DateTimeScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didRecive(model: DateTimeScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
}

// MARK: - DateTimeFactoryOutput

extension DateTimeViewController: DateTimeFactoryOutput {
  func didReverseListResult(model: DateTimeScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Private Appearance

extension DateTimeViewController {
  struct Appearance {
    let title = NSLocalizedString("Дата и время", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
