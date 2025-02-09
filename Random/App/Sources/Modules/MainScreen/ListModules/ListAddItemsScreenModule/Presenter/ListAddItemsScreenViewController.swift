//
//  ListAddItemsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 27.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ListAddItemsScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка удалить всех игроков
  func removeTextsButtonAction()
  
  /// Были получены данные
  ///  - Parameter models: Модельки с текстами
  func didReceiveText(models: [ListAddItemsScreenModel.TextModel])
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ListAddItemsScreenModuleInput {
  
  /// Удалить всех игроков
  func removeAllText()
  
  /// Обновить контент
  ///  - Parameter models: Модельки с текстами
  func updateContentWith(models: [ListAddItemsScreenModel.TextModel])
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ListAddItemsScreenModuleOutput? { get set }
}

/// Готовый модуль `ListAddItemsScreenModule`
typealias ListAddItemsScreenModule = ViewController & ListAddItemsScreenModuleInput

/// Презентер
final class ListAddItemsScreenViewController: ListAddItemsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ListAddItemsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ListAddItemsScreenInteractorInput
  private let moduleView: ListAddItemsScreenViewProtocol
  private let factory: ListAddItemsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ListAddItemsScreenViewProtocol,
       interactor: ListAddItemsScreenInteractorInput,
       factory: ListAddItemsScreenFactoryInput) {
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

    Metrics.shared.track(event: .listAddItemsScreenOpen)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    moduleOutput?.didReceiveText(models: interactor.returnCurrentListTextModel())
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()

    Metrics.shared.track(event: .listAddItemsScreenClose)
  }
  
  // MARK: - Internal func
  
  func removeAllText() {
    interactor.removeAllText()
  }
  
  func updateContentWith(models: [ListAddItemsScreenModel.TextModel]) {
    interactor.updateContentWith(models: models)
  }
}

// MARK: - ListAddItemsScreenViewOutput

extension ListAddItemsScreenViewController: ListAddItemsScreenViewOutput {
  func textAdded(_ text: String?) {
    interactor.textAdd(text)
    Metrics.shared.track(event: .listAddItemsScreenTextAdded)
  }
  
  func textRemoved(id: String) {
    interactor.textRemove(id: id)
    Metrics.shared.track(event: .listAddItemsScreenTextRemoved)
  }
}

// MARK: - ListAddItemsScreenInteractorOutput

extension ListAddItemsScreenViewController: ListAddItemsScreenInteractorOutput {
  func didReceiveText(models: [ListAddItemsScreenModel.TextModel]) {
    factory.createListModelFrom(models: models)
  }
}

// MARK: - ListAddItemsScreenFactoryOutput

extension ListAddItemsScreenViewController: ListAddItemsScreenFactoryOutput {
  func didReceive(models: [ListAddItemsScreenModel]) {
    moduleView.updateContentWith(models: models)
    
    if interactor.returnCurrentListTextModel().isEmpty {
      navigationItem.rightBarButtonItem?.isEnabled = false
    } else {
      navigationItem.rightBarButtonItem?.isEnabled = true
    }
  }
}

// MARK: - Private

private extension ListAddItemsScreenViewController {
  func setupNavBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.removePlayersButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(removePlayersButtonAction))
  }
  
  @objc
  func removePlayersButtonAction() {
    moduleOutput?.removeTextsButtonAction()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .listAddItemsScreenButtonNavigationRemoveTexts)
  }
}

// MARK: - Appearance

private extension ListAddItemsScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.list
    let removePlayersButtonIcon = UIImage(systemName: "trash")
  }
}
