//
//  CubesScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 15.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль
protocol CubesScreenModuleOutput: AnyObject {
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: CubesScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol CubesScreenModuleInput {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> CubesScreenModel
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: CubesScreenModuleOutput? { get set }
}

typealias CubesScreenModule = UIViewController & CubesScreenModuleInput

final class CubesScreenViewController: CubesScreenModule {

  weak var moduleOutput: CubesScreenModuleOutput?
  
  private let moduleView: CubesScreenViewProtocol
  private let interactor: CubesScreenInteractorInput
  private let factory: CubesScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: CubesScreenViewProtocol,
       interactor: CubesScreenInteractorInput,
       factory: CubesScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    interactor.getContent()
    setNavigationBar()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  func returnCurrentModel() -> CubesScreenModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  // MARK: - Private func
  
  private func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    let copyButton = UIBarButtonItem(image: appearance.copyButtonIcon,
                                     style: .plain,
                                     target: self,
                                     action: #selector(copyButtonAction))
    
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
  }
  
  @objc
  private func settingButtonAction() {
    moduleOutput?.settingButtonAction(model: interactor.returnCurrentModel())
  }
}

extension CubesScreenViewController: CubesScreenViewOutput {
  func updateSelectedCountCubes(_ count: Int) {
    interactor.updateSelectedCountCubes(count)
  }
  
  func generateButtonAction() {
    interactor.generateButtonAction()
  }
}

extension CubesScreenViewController: CubesScreenInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didRecive(model: CubesScreenModel) {
    moduleView.updateContentWith(selectedCountCubes: model.selectedCountCubes,
                                 cubesType: model.cubesType,
                                 listResult: factory.reverseListResult(model.listResult),
                                 plagIsShow: model.listResult.isEmpty)
  }
}

extension CubesScreenViewController: CubesScreenFactoryOutput {}

extension CubesScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = NSLocalizedString("Кубики", comment: "")
    let copyButtonIcon = UIImage(systemName: "doc.on.doc")
  }
}
