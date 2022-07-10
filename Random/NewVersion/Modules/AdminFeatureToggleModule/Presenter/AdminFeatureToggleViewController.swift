//
//  AdminFeatureToggleViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.07.2022.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol AdminFeatureToggleModuleOutput: AnyObject {
  
  /// Неверный логин или пароль
  func loginOrPasswordError()
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol AdminFeatureToggleModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: AdminFeatureToggleModuleOutput? { get set }
}

/// Готовый модуль `AdminFeatureToggleModule`
typealias AdminFeatureToggleModule = UIViewController & AdminFeatureToggleModuleInput

/// Презентер
final class AdminFeatureToggleViewController: AdminFeatureToggleModule {
  
  // MARK: - Public properties
  
  // MARK: - Internal properties
  
  weak var moduleOutput: AdminFeatureToggleModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: AdminFeatureToggleInteractorInput
  private let moduleView: AdminFeatureToggleViewProtocol
  private let factory: AdminFeatureToggleFactoryInput
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(interactor: AdminFeatureToggleInteractorInput,
       moduleView: AdminFeatureToggleViewProtocol,
       factory: AdminFeatureToggleFactoryInput) {
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
    
    title = Appearance().title
  }
}

// MARK: - AdminFeatureToggleViewOutput

extension AdminFeatureToggleViewController: AdminFeatureToggleViewOutput {
  func saveSettingsButtonAction() {
    // TODO: -
  }
  
  func loginButtonAction(login: String, password: String) {
    moduleView.startLoader()
    interactor.cheak(login: login, password: password)
  }
  
  func loginOrPasswordError() {
    moduleOutput?.loginOrPasswordError()
  }
}

// MARK: - AdminFeatureToggleInteractorOutput

extension AdminFeatureToggleViewController: AdminFeatureToggleInteractorOutput {
  func didReciveFeature(toggles: [MainScreenCellModel.MainScreenCell]) {
    factory.createModelsFrom(featureToggles: toggles)
  }
  
  func loginOrPasswordFailure() {
    moduleOutput?.loginOrPasswordError()
    moduleView.stopLoader()
  }
  
  func loginOrPasswordSuccess() {
    moduleView.stopLoader()
    moduleView.loginPage(isShow: false)
    interactor.getFeatureToggles()
  }
}

// MARK: - AdminFeatureToggleFactoryOutput

extension AdminFeatureToggleViewController: AdminFeatureToggleFactoryOutput {
  func didRecive(models: [AdminFeatureToggleModel]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Appearance

private extension AdminFeatureToggleViewController {
  struct Appearance {
    let title = "Admin panel"
  }
}
