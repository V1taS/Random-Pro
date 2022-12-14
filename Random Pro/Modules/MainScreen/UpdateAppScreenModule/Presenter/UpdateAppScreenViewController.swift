//
//  UpdateAppScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol UpdateAppScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol UpdateAppScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: UpdateAppScreenModuleOutput? { get set }
}

/// Готовый модуль `UpdateAppScreenModule`
typealias UpdateAppScreenModule = UIViewController & UpdateAppScreenModuleInput

/// Презентер
final class UpdateAppScreenViewController: UpdateAppScreenModule {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var moduleOutput: UpdateAppScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: UpdateAppScreenInteractorInput
  private let moduleView: UpdateAppScreenViewProtocol
  private let factory: UpdateAppScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: UpdateAppScreenViewProtocol,
       interactor: UpdateAppScreenInteractorInput,
       factory: UpdateAppScreenFactoryInput) {
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
  }
}

// MARK: - UpdateAppScreenViewOutput

extension UpdateAppScreenViewController: UpdateAppScreenViewOutput {}

// MARK: - UpdateAppScreenInteractorOutput

extension UpdateAppScreenViewController: UpdateAppScreenInteractorOutput {}

// MARK: - UpdateAppScreenFactoryOutput

extension UpdateAppScreenViewController: UpdateAppScreenFactoryOutput {}

// MARK: - Private

private extension UpdateAppScreenViewController {
  func setupNavBar() {
    navigationItem.largeTitleDisplayMode = .never
  }
}

// MARK: - Appearance

private extension UpdateAppScreenViewController {
  struct Appearance {}
}
