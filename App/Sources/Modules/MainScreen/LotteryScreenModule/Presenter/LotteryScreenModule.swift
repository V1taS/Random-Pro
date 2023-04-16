//
//  LotteryScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol LotteryScreenModuleOutput: AnyObject {
  
  /// Неправильный диапазон чисел
  func didReceiveRangeError()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: LotteryScreenModel)
  
  /// Кнопка очистить была нажата
  /// - Parameter model: результат генерации
  func cleanButtonWasSelected(model: LotteryScreenModel)
  
  /// Было нажатие на результат генерации
  ///  - Parameter model: Результат генерации
  func resultLabelAction(model: LotteryScreenModel)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol LotteryScreenModuleInput {
  
  /// Возвращает список результатов
  func returnListResult() -> [String]
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: LotteryScreenModuleOutput? { get set }
}

typealias LotteryScreenModule = UIViewController & LotteryScreenModuleInput

final class LotteryScreenViewController: LotteryScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: LotteryScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: LotteryScreenViewProtocol
  private let interactor: LotteryScreenInteractorInput
  private let factory: LotteryScreenFactoryInput
  private var cacheModel: LotteryScreenModel?
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
  init(moduleView: LotteryScreenViewProtocol,
       interactor: LotteryScreenInteractorInput,
       factory: LotteryScreenFactoryInput) {
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
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
  
  // MARK: - Internal func
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func returnListResult() -> [String] {
    interactor.returnListResult()
  }
}

// MARK: - LotteryScreenViewOutput

extension LotteryScreenViewController: LotteryScreenViewOutput {
  func generateButtonAction(rangeStartValue: String?, rangeEndValue: String?, amountNumberValue: String?) {
    interactor.generateContent(rangeStartValue: rangeStartValue,
                               rangeEndValue: rangeEndValue, amountNumberValue: amountNumberValue)
  }
}

// MARK: - LotteryScreenInteractorOutput

extension LotteryScreenViewController: LotteryScreenInteractorOutput {
  func cleanButtonWasSelected(model: LotteryScreenModel) {
    cacheModel = model
    moduleOutput?.cleanButtonWasSelected(model: model)
  }
  
  func didReceive(model: LotteryScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
  
  func didReceiveRangeError() {
    moduleOutput?.didReceiveRangeError()
  }
}

// MARK: - LotteryScreenFactoryOutput

extension LotteryScreenViewController: LotteryScreenFactoryOutput {
  func didReverseListResult(model: LotteryScreenModel) {
    moduleView.updateContentWith(model: model)
    copyButton.isEnabled = !interactor.returnListResult().isEmpty
  }
}

// MARK: - Private

private extension LotteryScreenViewController {
  func setNavigationBar() {
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
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.resultLabelAction(model: model)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    guard let cacheModel = cacheModel else { return }
    moduleOutput?.settingButtonAction(model: cacheModel)
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension LotteryScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = NSLocalizedString("Лотерея", comment: "")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
  }
}
