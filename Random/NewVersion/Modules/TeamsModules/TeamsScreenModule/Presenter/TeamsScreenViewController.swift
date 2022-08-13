//
//  TeamsScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.08.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol TeamsScreenModuleOutput: AnyObject {
  
  /// Была нажата кнопка (настройки)
  /// - Parameter model: результат генерации
  func settingButtonAction(model: TeamsScreenModel)
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol TeamsScreenModuleInput {
  
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
  private var cacheModel: TeamsScreenModel?
  
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
}

// MARK: - TeamsScreenViewOutput

extension TeamsScreenViewController: TeamsScreenViewOutput {}

// MARK: - TeamsScreenInteractorOutput

extension TeamsScreenViewController: TeamsScreenInteractorOutput {
  func didRecive(model: TeamsScreenModel) {
    cacheModel = model
  }
}

// MARK: - TeamsScreenFactoryOutput

extension TeamsScreenViewController: TeamsScreenFactoryOutput {}

// MARK: - Private

private extension TeamsScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc
  func settingButtonAction() {
    guard let cacheModel = cacheModel else {
      return
    }
    moduleOutput?.settingButtonAction(model: cacheModel)
  }
}

// MARK: - Appearance

private extension TeamsScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Команды", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
