//
//  YesNoScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public protocol YesNoScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: YesNoScreenModelProtocol)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: YesNoScreenModelProtocol)
}

public protocol YesNoScreenModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: YesNoScreenModuleOutput? { get set }
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

public typealias YesNoScreenModule = UIViewController & YesNoScreenModuleInput

final class YesNoScreenViewController: YesNoScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: YesNoScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: YesNoScreenViewProtocol
  private let interactor: YesNoScreenInteractorInput
  private let factory: YesNoScreenFactoryInput
  private var cacheModel: YesNoScreenModel?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
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
    let title = NSLocalizedString("Да или Нет", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
