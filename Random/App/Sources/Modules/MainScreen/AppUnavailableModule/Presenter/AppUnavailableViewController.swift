//
//  AppUnavailableViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// Презентер
final class AppUnavailableViewController: AppUnavailableModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: AppUnavailableModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: AppUnavailableInteractorInput
  private let moduleView: AppUnavailableViewProtocol
  private let factory: AppUnavailableFactoryInput
  private let services: ApplicationServices
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  ///   - services: Сервисы
  init(moduleView: AppUnavailableViewProtocol,
       interactor: AppUnavailableInteractorInput,
       factory: AppUnavailableFactoryInput,
       services: ApplicationServices) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    self.services = services
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
    
    setNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    moduleView.startStubAnimation()
    
    let isAppBroken = services.featureToggleServices.isToggleFor(feature: .isAppBroken)
    if !isAppBroken {
      moduleOutput?.closeAction()
    }
  }
}

// MARK: - AppUnavailableViewOutput

extension AppUnavailableViewController: AppUnavailableViewOutput {
  func feedBackButtonAction() {
    moduleOutput?.feedBackButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - AppUnavailableInteractorOutput

extension AppUnavailableViewController: AppUnavailableInteractorOutput {}

// MARK: - AppUnavailableFactoryOutput

extension AppUnavailableViewController: AppUnavailableFactoryOutput {}

// MARK: - Private

private extension AppUnavailableViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .always
    title = appearance.title
  }
}

// MARK: - Appearance

private extension AppUnavailableViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
  }
}
