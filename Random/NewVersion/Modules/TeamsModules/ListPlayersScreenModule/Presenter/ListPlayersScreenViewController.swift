//
//  ListPlayersScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol ListPlayersScreenModuleOutput: AnyObject {
  
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol ListPlayersScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: ListPlayersScreenModuleOutput? { get set }
}

/// Готовый модуль `ListPlayersScreenModule`
typealias ListPlayersScreenModule = UIViewController & ListPlayersScreenModuleInput

/// Презентер
final class ListPlayersScreenViewController: ListPlayersScreenModule {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ListPlayersScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ListPlayersScreenInteractorInput
  private let moduleView: ListPlayersScreenViewProtocol
  private let factory: ListPlayersScreenFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: ListPlayersScreenInteractorInput,
       moduleView: ListPlayersScreenViewProtocol,
       factory: ListPlayersScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
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
    
    title = "Appearance().title"
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: - ListPlayersScreenViewOutput

extension ListPlayersScreenViewController: ListPlayersScreenViewOutput {
  func addedPlayer(neme: String?) {
    // TODO: -
  }
}

// MARK: - ListPlayersScreenInteractorOutput

extension ListPlayersScreenViewController: ListPlayersScreenInteractorOutput {
  func didRecive(models: [ListPlayersScreenModel.Player]) {
    factory.createListModelFrom(players: models)
  }
}

// MARK: - ListPlayersScreenFactoryOutput

extension ListPlayersScreenViewController: ListPlayersScreenFactoryOutput {
  func didRecive(model: [ListPlayersScreenType]) {
    moduleView.updateContentWith(models: model)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenViewController {
  struct Appearance {
    
  }
}
