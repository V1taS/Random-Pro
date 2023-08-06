//
//  PlayerCardSelectionScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.02.2023.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PlayerCardSelectionScreenModuleOutput: AnyObject {
  
  /// Нет премиум доступа
  func noPremiumAccessAction()
  
  /// Успешно выбран стиль карточки
  func didSelectStyleSuccessfully()
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol PlayerCardSelectionScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: PlayerCardSelectionScreenModuleOutput? { get set }
}

/// Готовый модуль `PlayerCardSelectionScreenModule`
typealias PlayerCardSelectionScreenModule = ViewController & PlayerCardSelectionScreenModuleInput

/// Презентер
final class PlayerCardSelectionScreenViewController: PlayerCardSelectionScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: PlayerCardSelectionScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: PlayerCardSelectionScreenInteractorInput
  private let moduleView: PlayerCardSelectionScreenViewProtocol
  private let factory: PlayerCardSelectionScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: PlayerCardSelectionScreenViewProtocol,
       interactor: PlayerCardSelectionScreenInteractorInput,
       factory: PlayerCardSelectionScreenFactoryInput) {
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - PlayerCardSelectionScreenViewOutput

extension PlayerCardSelectionScreenViewController: PlayerCardSelectionScreenViewOutput {
  func didSelectStyleSuccessfully() {
    moduleOutput?.didSelectStyleSuccessfully()
  }
  
  func noPremiumAccessAction() {
    moduleOutput?.noPremiumAccessAction()
  }
  
  func didSelect(style: PlayerView.StyleCard, with models: [PlayerCardSelectionScreenModel]) {
    interactor.savePlayerCardStyle(style, with: models)
    factory.createModelWith(selectStyle: style,
                            with: models,
                            isPremium: interactor.getIsPremium())
  }
}

// MARK: - PlayerCardSelectionScreenInteractorOutput

extension PlayerCardSelectionScreenViewController: PlayerCardSelectionScreenInteractorOutput {
  func didReceive(models: [PlayerCardSelectionScreenModel], isPremium: Bool) {
    factory.updateModels(models, isPremium: isPremium)
  }
  
  func didReceiveEmptyModelWith(isPremium: Bool) {
    factory.createInitialModelWith(isPremium: isPremium)
  }
}

// MARK: - PlayerCardSelectionScreenFactoryOutput

extension PlayerCardSelectionScreenViewController: PlayerCardSelectionScreenFactoryOutput {
  func didGenerated(models: [PlayerCardSelectionScreenModel]) {
    let styleCard = models.filter({ $0.playerCardSelection }).first?.style ?? .defaultStyle
    moduleView.updateContentWith(models: models)
    interactor.savePlayerCardStyle(styleCard, with: models)
  }
}

// MARK: - Private

private extension PlayerCardSelectionScreenViewController {
  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.title
  }
}

// MARK: - Appearance

private extension PlayerCardSelectionScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.cardStyle
  }
}
