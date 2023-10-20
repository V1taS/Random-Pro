//
//  CubesScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль
protocol CubesScreenModuleOutput: AnyObject {
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: CubesScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol CubesScreenModuleInput {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CubesScreenModel
  
  /// Показать список генераций результатов
  /// - Parameter isShow: показать  список генераций результатов
  func listGenerated(isShow: Bool)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: CubesScreenModuleOutput? { get set }
}

typealias CubesScreenModule = ViewController & CubesScreenModuleInput

final class CubesScreenViewController: CubesScreenModule {
  
  weak var moduleOutput: CubesScreenModuleOutput?
  
  private let moduleView: CubesScreenViewProtocol
  private let interactor: CubesScreenInteractorInput
  private let factory: CubesScreenFactoryInput
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
  init(moduleView: CubesScreenViewProtocol,
       interactor: CubesScreenInteractorInput,
       factory: CubesScreenFactoryInput) {
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
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> CubesScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func listGenerated(isShow: Bool) {
    moduleView.listGenerated(isShow: isShow)
    interactor.listGenerated(isShow: isShow)
  }
}

// MARK: - CubesScreenViewOutput

extension CubesScreenViewController: CubesScreenViewOutput {
  func playHapticFeedbackAction() {
    interactor.playHapticFeedback()
  }

  func updateSelectedCountCubes(_ cubesType: CubesScreenModel.CubesType) {
    interactor.updateSelectedCountCubes(cubesType)
  }
  
  func diceAction(totalValue: Int) {
    interactor.diceAction(totalValue: totalValue)
    let listResult = factory.reverseListResult(interactor.returnCurrentModel().listResult)
    moduleView.updateContentWith(listResult: listResult)
  }
}

// MARK: - CubesScreenInteractorOutput

extension CubesScreenViewController: CubesScreenInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceive(model: CubesScreenModel) {
    moduleView.updateContentWith(model: model)
    copyButton.isEnabled = !interactor.returnCurrentModel().listResult.isEmpty
    moduleView.listGenerated(isShow: model.isShowlistGenerated)
  }
}

// MARK: - CubesScreenFactoryOutput

extension CubesScreenViewController: CubesScreenFactoryOutput {}

// MARK: - Private

private extension CubesScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.navBarTitle
    
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
    guard let result = interactor.returnCurrentModel().listResult.last else {
      return
    }
    moduleOutput?.resultCopied(text: result)
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

extension CubesScreenViewController {
  struct Appearance {
    
    let settingsButtonIcon = UIImage(systemName: "gear")
    let navBarTitle = RandomStrings.Localizable.cubes
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
  }
}
