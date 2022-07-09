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
  func settingButtonAction()
}

protocol DateTimeModuleInput: AnyObject {
  
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
  
  @objc private func settingButtonAction() {
    moduleOutput?.settingButtonAction()
  }
}

// MARK: - DateTimeViewOutput

extension DateTimeViewController: DateTimeViewOutput {
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
  func didRecive(result: String?) {
    moduleView.set(result: result)
  }
  
  func didRecive(listResult: [String]) {
    factory.reverse(listResult: listResult)
  }
}

// MARK: - DateTimeFactoryOutput

extension DateTimeViewController: DateTimeFactoryOutput {
  func didReverse(listResult: [String]) {
    moduleView.set(listResult: listResult)
  }
}

// MARK: - Private Appearance

extension DateTimeViewController {
  struct Appearance {
    let title = NSLocalizedString("Дата и время", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
