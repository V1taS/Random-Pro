//
//  CoinScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 17.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

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
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol CoinScreenModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CoinScreenModuleOutput? { get set }
}

typealias CoinScreenModule = UIViewController & CoinScreenModuleInput

final class CoinScreenViewController: CoinScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: CoinScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: CoinScreenViewProtocol
  private let interactor: CoinScreenInteractorInput
  private let factory: CoinScreenFactoryInput
  private var cacheModel: CoinScreenModel?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnListResult() -> [String] {
    interactor.returnListResult()
  }
}

// MARK: - CoinScreenViewOutput

extension CoinScreenViewController: CoinScreenViewOutput {
  func generateButtonAction() {
    interactor.generateContentCoin()
    interactor.playHapticFeedback()
  }
  
  func resultLabelAction(text: String?) {
    moduleOutput?.resultLabelAction(text: text)
  }
}

// MARK: - CoinScreenInteractorOutput

extension CoinScreenViewController: CoinScreenInteractorOutput {
  func cleanButtonWasSelected(model: CoinScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: CoinScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingsButtonAction))
  }
  
  @objc
  func settingsButtonAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: model)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension CoinScreenViewController {
  struct Appearance {
    let title =  NSLocalizedString("Орел или Pешка", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
