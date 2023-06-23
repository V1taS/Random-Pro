//
//  FortuneWheelViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomWheel

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol FortuneWheelModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  func settingButtonAction()
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Выбрать ячейку было нажато
  func selectedSectionAction()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol FortuneWheelModuleInput {
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> FortuneWheelModel
  
  /// Включить тактильный отклик
  /// - Parameter isEnabled: Значение
  func setFeedback(isEnabled: Bool)
  
  /// Обновить текущую модель
  ///  - Parameter model: Модель данных
  func updateNew(model: FortuneWheelModel)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: FortuneWheelModuleOutput? { get set }
}

/// Готовый модуль `FortuneWheelModule`
typealias FortuneWheelModule = UIViewController & FortuneWheelModuleInput

/// Презентер
final class FortuneWheelViewController: FortuneWheelModule {

  // MARK: - Internal properties
  
  weak var moduleOutput: FortuneWheelModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: FortuneWheelInteractorInput
  private let moduleView: FortuneWheelViewProtocol
  private let factory: FortuneWheelFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: FortuneWheelViewProtocol,
       interactor: FortuneWheelInteractorInput,
       factory: FortuneWheelFactoryInput) {
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
  
  func returnCurrentModel() -> FortuneWheelModel {
    interactor.returnCurrentModel()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
  
  func setFeedback(isEnabled: Bool) {
    interactor.setFeedback(isEnabled: isEnabled)
  }
  
  func updateNew(model: FortuneWheelModel) {
    interactor.updateNew(model: model)
  }
}

// MARK: - FortuneWheelViewOutput

extension FortuneWheelViewController: FortuneWheelViewOutput {
  func save(result: String) {
    interactor.save(result: result)
  }
  
  func selectedSectionAction() {
    moduleOutput?.selectedSectionAction()
  }
}

// MARK: - FortuneWheelInteractorOutput

extension FortuneWheelViewController: FortuneWheelInteractorOutput {
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
  }
  
  func didReceive(model: FortuneWheelModel) {
    moduleView.setupFortuneWheelWith(model: model)
  }
}

// MARK: - FortuneWheelFactoryOutput

extension FortuneWheelViewController: FortuneWheelFactoryOutput {}

// MARK: - Private

private extension FortuneWheelViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
    ]
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension FortuneWheelViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.fortuneWheel
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
