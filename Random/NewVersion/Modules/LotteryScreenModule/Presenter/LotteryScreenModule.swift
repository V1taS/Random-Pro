//
//  LotteryScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LotteryScreenModuleOutput: AnyObject {
  /// Неправильный диапазон чисел
  func didReciveRangeError()
  
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

protocol LotteryScreenModuleInput: AnyObject {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
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
  
  // MARK: - Initialization
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: LotteryScreenViewProtocol, interactor: LotteryScreenInteractorInput,
       factory: LotteryScreenFactoryInput) {
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

// MARK: - LotteryScreenViewOutput

extension LotteryScreenViewController: LotteryScreenViewOutput {
  func resultLabelAction() {
    guard let model = cacheModel else {
      return
    }
    moduleOutput?.resultLabelAction(model: model)
  }
  
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
  
  func didRecive(model: LotteryScreenModel) {
    cacheModel = model
    factory.reverseListResultFrom(model: model)
  }
  
  func didReciveRangeError() {
    moduleOutput?.didReciveRangeError()
  }
}

// MARK: - LotteryScreenFactoryOutput

extension LotteryScreenViewController: LotteryScreenFactoryOutput {
  func didReverseListResult(model: LotteryScreenModel) {
    moduleView.updateContentWith(model: model)
  }
}

// MARK: - Appearance

private extension LotteryScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = NSLocalizedString("Лотерея", comment: "")
  }
}
