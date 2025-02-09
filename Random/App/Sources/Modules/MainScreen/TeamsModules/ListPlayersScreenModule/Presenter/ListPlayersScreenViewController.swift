//
//  ListPlayersScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.08.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ListPlayersScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка удалить всех игроков
  func removePlayersButtonAction()
  
  /// Были получены игроки
  ///  - Parameter players: Список игроков
  func didReceive(players: [TeamsScreenPlayerModel])
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ListPlayersScreenModuleInput {
  
  /// Удалить всех игроков
  func removeAllPlayers()
  
  /// Обновить контент
  ///  - Parameters:
  ///   - models: Модели игроков
  ///   - teamsCount: Общее количество игроков
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ListPlayersScreenModuleOutput? { get set }
}

/// Готовый модуль `ListPlayersScreenModule`
typealias ListPlayersScreenModule = ViewController & ListPlayersScreenModuleInput

/// Презентер
final class ListPlayersScreenViewController: ListPlayersScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ListPlayersScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ListPlayersScreenInteractorInput
  private let moduleView: ListPlayersScreenViewProtocol
  private let factory: ListPlayersScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ListPlayersScreenViewProtocol,
       interactor: ListPlayersScreenInteractorInput,
       factory: ListPlayersScreenFactoryInput) {
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
    
    setupNavBar()
    interactor.getContent()
    Metrics.shared.track(event: .listPlayersScreenOpen)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    moduleOutput?.didReceive(players: interactor.returnCurrentListPlayers())
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .listPlayersScreenClose)
  }
  
  // MARK: - Internal func
  
  func updateContentWith(models: [TeamsScreenPlayerModel], teamsCount: Int) {
    interactor.updateContentWith(models: models, teamsCount: teamsCount)
  }
  
  func removeAllPlayers() {
    interactor.removeAllPlayers()
  }
}

// MARK: - ListPlayersScreenViewOutput

extension ListPlayersScreenViewController: ListPlayersScreenViewOutput {
  func genderValueChanged(_ index: Int) {
    interactor.genderValueChanged(index)
    Metrics.shared.track(event: .listPlayersScreenGenderValueChanged)
  }
  
  func playerRemoved(id: String) {
    interactor.playerRemove(id: id)
    Metrics.shared.track(event: .listPlayersScreenPlayerRemoved)
  }
  
  func updateContent() {
    interactor.getContent()
  }
  
  func updatePlayer(state: TeamsScreenPlayerModel.PlayerState, id: String) {
    interactor.updatePlayer(state: state, id: id)
    Metrics.shared.track(event: .listPlayersScreenUpdatePlayer)
  }
  
  func updatePlayer(emoji: String, id: String) {
    interactor.updatePlayer(emoji: emoji, id: id)
    Metrics.shared.track(event: .listPlayersScreenUpdatePlayer)
  }
  
  func playerAdded(name: String?) {
    interactor.playerAdd(name: name)
    Metrics.shared.track(event: .listPlayersScreenPlayerAdded)
  }
}

// MARK: - ListPlayersScreenInteractorOutput

extension ListPlayersScreenViewController: ListPlayersScreenInteractorOutput {
  func didReceive(players: [TeamsScreenPlayerModel], teamsCount: Int) {
    factory.createListModelFrom(players: players, teamsCount: teamsCount)
  }
}

// MARK: - ListPlayersScreenFactoryOutput

extension ListPlayersScreenViewController: ListPlayersScreenFactoryOutput {
  func didReceive(models: [ListPlayersScreenType]) {
    moduleView.updateContentWith(models: models)
    
    if interactor.returnCurrentListPlayers().isEmpty {
      navigationItem.rightBarButtonItem?.isEnabled = false
    } else {
      navigationItem.rightBarButtonItem?.isEnabled = true
    }
  }
}

// MARK: - Private

private extension ListPlayersScreenViewController {
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
    moduleOutput?.removePlayersButtonAction()
    impactFeedback.impactOccurred()
    Metrics.shared.track(event: .listPlayersScreenPlayerRemoved)
  }
}

// MARK: - Appearance

private extension ListPlayersScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.listOfPlayers
    let removePlayersButtonIcon = UIImage(systemName: "trash")
  }
}
