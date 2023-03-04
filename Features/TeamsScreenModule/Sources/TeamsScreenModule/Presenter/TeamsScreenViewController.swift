//
//  TeamsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
public protocol TeamsScreenModuleOutput: AnyObject {
  
  /// Список игроков пуст
  func listPlayersIsEmpty()
  
  /// Была нажата кнопка (настройки)
  /// - Parameter players: список игроков
  func settingButtonAction(players: [TeamsScreenPlayerModelProtocol])
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
public protocol TeamsScreenModuleInput {
  
  /// Возвращает текущее количество команд
  func returnGeneratedCountTeams() -> Int
  
  /// Возвращает список команд
  func returnListTeams() -> [TeamsScreenTeamModelProtocol]
  
  /// Возвращает сколько выбрано команд
  func returnSelectedTeam() -> Int
  
  /// Возвращает список игроков
  func returnListPlayers() -> [TeamsScreenPlayerModelProtocol]
  
  /// Количество сгенерированных игроков
  func returnGeneratedCountPlayers() -> Int
  
  /// Обновить список игроков
  ///  - Parameter players: Список игроков
  func updateContentWith(players: [TeamsScreenPlayerModelProtocol])
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: TeamsScreenModuleOutput? { get set }
}

/// Готовый модуль `TeamsScreenModule`
public typealias TeamsScreenModule = UIViewController & TeamsScreenModuleInput

/// Презентер
final class TeamsScreenViewController: TeamsScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: TeamsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: TeamsScreenInteractorInput
  private let moduleView: TeamsScreenViewProtocol
  private let factory: TeamsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private lazy var shareButton = UIBarButtonItem(image: Appearance().shareButtonIcon,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(shareButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: TeamsScreenViewProtocol,
       interactor: TeamsScreenInteractorInput,
       factory: TeamsScreenFactoryInput) {
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
    shareButton.isEnabled = !interactor.returnListTeams().isEmpty
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor.updateStyle()
  }
  
  // MARK: - Internal func
  
  func updateContentWith(players: [TeamsScreenPlayerModelProtocol]) {
    guard let players = players as? [TeamsScreenPlayerModel] else {
      return
    }
    interactor.updateContentWith(players: players)
  }
  
  func returnGeneratedCountTeams() -> Int {
    interactor.returnCountTeams()
  }
  
  func returnListTeams() -> [TeamsScreenTeamModelProtocol] {
    interactor.returnListTeams()
  }
  
  func returnListPlayers() -> [TeamsScreenPlayerModelProtocol] {
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
  func didReceiveEmptyListTeams() {
    moduleView.plugIsShow(true)
    shareButton.isEnabled = !interactor.returnListTeams().isEmpty
  }
  
  func didReceive(model: TeamsScreenModel) {
    moduleView.updateContentWith(models: model.teams,
                                 teamsCount: interactor.returnSelectedTeam())
    moduleView.plugIsShow(model.teams.isEmpty)
    shareButton.isEnabled = !interactor.returnListTeams().isEmpty
  }
  
  func cleanButtonWasSelected() {
    moduleOutput?.cleanButtonWasSelected()
    factory.createTeamsFrom(model: TeamsScreenModel(selectedTeam: 2, allPlayers: [], teams: []))
  }
}

// MARK: - TeamsScreenFactoryOutput

extension TeamsScreenViewController: TeamsScreenFactoryOutput {
  func didReceive(teams: [TeamsScreenModel.Team]) {
    interactor.updateList(teams: teams)
    moduleView.updateContentWith(models: teams,
                                 teamsCount: interactor.returnSelectedTeam())
    moduleView.plugIsShow(teams.isEmpty)
    shareButton.isEnabled = !interactor.returnListTeams().isEmpty
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
    generateButton.tintColor = RandomColor.only.primaryGreen
    
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      generateButton,
      shareButton
    ]
  }
  
  @objc
  func shareButtonAction() {
    moduleView.returnCurrentContentImage { [weak self] imgData in
      self?.moduleOutput?.shareButtonAction(imageData: imgData)
      self?.impactFeedback.impactOccurred()
    }
  }
  
  @objc
  func generateButtonAction() {
    if interactor.returnModel().allPlayers.isEmpty {
      moduleOutput?.listPlayersIsEmpty()
    } else {
      factory.createTeamsFrom(model: interactor.returnModel())
    }
    impactFeedback.impactOccurred()
  }
  
  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction(players: interactor.returnListPlayers())
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension TeamsScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Команды", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
    let generateButtonIcon = UIImage(systemName: "forward.end.fill")
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
  }
}
