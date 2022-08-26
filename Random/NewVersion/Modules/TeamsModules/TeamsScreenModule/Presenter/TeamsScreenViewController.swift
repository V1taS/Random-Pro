//
//  TeamsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol TeamsScreenModuleOutput: AnyObject {
  
  /// Список игроков пуст
  func listPlayersIsEmpty()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter players: список игроков
  func settingButtonAction(players: [TeamsScreenPlayerModel])
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol TeamsScreenModuleInput {
  
  /// Возвращает текущее количество команд
  func returnGeneratedCountTeams() -> Int
  
  /// Возвращает список команд
  func returnListTeams() -> [TeamsScreenModel.Team]
  
  /// Возвращает сколько выбрано команд
  func returnSelectedTeam() -> Int
  
  /// Возвращает список игроков
  func returnListPlayers() -> [TeamsScreenPlayerModel]
  
  /// Количество сгенерированных игроков
  func returnGeneratedCountPlayers() -> Int
  
  /// Обновить список игроков
  ///  - Parameter players: Список игроков
  func updateContentWith(players: [TeamsScreenPlayerModel])
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: TeamsScreenModuleOutput? { get set }
}

/// Готовый модуль `TeamsScreenModule`
typealias TeamsScreenModule = UIViewController & TeamsScreenModuleInput

/// Презентер
final class TeamsScreenViewController: TeamsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: TeamsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: TeamsScreenInteractorInput
  private let moduleView: TeamsScreenViewProtocol
  private let factory: TeamsScreenFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: TeamsScreenInteractorInput,
       moduleView: TeamsScreenViewProtocol,
       factory: TeamsScreenFactoryInput) {
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
    setNavigationBar()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(players: [TeamsScreenPlayerModel]) {
    interactor.updateContentWith(players: players)
  }
  
  func returnGeneratedCountTeams() -> Int {
    interactor.returnCountTeams()
  }
  
  func returnListTeams() -> [TeamsScreenModel.Team] {
    interactor.returnListTeams()
  }
  
  func returnListPlayers() -> [TeamsScreenPlayerModel] {
    interactor.returnListPlayers()
  }
  
  func returnGeneratedCountPlayers() -> Int {
    interactor.returnGeneratedCountPlayers()
  }
  
  func returnSelectedTeam() -> Int {
    interactor.returnSelectedTeam()
  }
  
  func cleanButtonAction() {
    interactor.cleanButtonAction()
  }
}

// MARK: - TeamsScreenViewOutput

extension TeamsScreenViewController: TeamsScreenViewOutput {
  func updateTeams(count: Int) {
    interactor.updateTeams(count: count)
  }
}

// MARK: - TeamsScreenInteractorOutput

extension TeamsScreenViewController: TeamsScreenInteractorOutput {
  func didReciveEmptyListTeams() {
    moduleView.plugIsShow(true)
  }
  
  func didRecive(model: TeamsScreenModel) {
    moduleView.updateContentWith(models: model.teams,
                                 teamsCount: interactor.returnSelectedTeam())
    moduleView.plugIsShow(model.teams.isEmpty)
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
    factory.createTeamsFrom(model: TeamsScreenModel(selectedTeam: 2, allPlayers: [], teams: []))
  }
}

// MARK: - TeamsScreenFactoryOutput

extension TeamsScreenViewController: TeamsScreenFactoryOutput {
  func didRecive(teams: [TeamsScreenModel.Team]) {
    interactor.updateList(teams: teams)
    moduleView.updateContentWith(models: teams,
                                 teamsCount: interactor.returnSelectedTeam())
    moduleView.plugIsShow(teams.isEmpty)
  }
}

// MARK: - Private

private extension TeamsScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    let generateButton = UIBarButtonItem(image: appearance.generateButtonIcon,
                                         style: .plain,
                                         target: self,
                                         action: #selector(generateButtonAction))
    generateButton.tintColor = RandomColor.primaryGreen
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      generateButton
    ]
  }
  
  @objc
  func generateButtonAction() {
    if interactor.returnModel().allPlayers.isEmpty {
      moduleOutput?.listPlayersIsEmpty()
    } else {
      factory.createTeamsFrom(model: interactor.returnModel())
    }
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(players: interactor.returnListPlayers())
  }
}

// MARK: - Appearance

private extension TeamsScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Команды", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
    let generateButtonIcon = UIImage(systemName: "forward.end.fill")
  }
}
