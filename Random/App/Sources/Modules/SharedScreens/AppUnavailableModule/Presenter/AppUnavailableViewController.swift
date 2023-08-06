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
    moduleView.startStubAnimation()
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(didBecomeActiveNotification),
                                           name: UIApplication.didBecomeActiveNotification,
                                           object: nil)
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
    navigationController?.navigationBar.prefersLargeTitles = true
    title = appearance.title
  }
  
  @objc
  func didBecomeActiveNotification() {
    services.featureToggleServices.fetchRemoteConfig { [weak self] _ in
      guard let self else {
        return
      }
      let isAppBroken = self.services.featureToggleServices.isToggleFor(feature: .isAppBroken)
      if !isAppBroken {
        self.moduleOutput?.closeModuleAction()
        self.moduleOutput?.moduleClosed()
      }
    }
  }
}

// MARK: - Appearance

private extension AppUnavailableViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
  }
}
