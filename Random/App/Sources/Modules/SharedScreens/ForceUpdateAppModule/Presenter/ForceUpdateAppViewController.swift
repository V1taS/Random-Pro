//
//  ForceUpdateAppViewController.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//

import UIKit

/// Презентер
final class ForceUpdateAppViewController: ForceUpdateAppModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ForceUpdateAppModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ForceUpdateAppInteractorInput
  private let moduleView: ForceUpdateAppViewProtocol
  private let factory: ForceUpdateAppFactoryInput
  private let services: ApplicationServices
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  ///   - services: сервисы
  init(moduleView: ForceUpdateAppViewProtocol,
       interactor: ForceUpdateAppInteractorInput,
       factory: ForceUpdateAppFactoryInput,
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

// MARK: - ForceUpdateAppViewOutput

extension ForceUpdateAppViewController: ForceUpdateAppViewOutput {
  func updateButtonAction() {
    moduleOutput?.updateButtonAction()
  }
}

// MARK: - ForceUpdateAppInteractorOutput

extension ForceUpdateAppViewController: ForceUpdateAppInteractorOutput {}

// MARK: - ForceUpdateAppFactoryOutput

extension ForceUpdateAppViewController: ForceUpdateAppFactoryOutput {}

// MARK: - Private

private extension ForceUpdateAppViewController {
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
      let isForceUpdateAvailable = self.services.featureToggleServices.isToggleFor(feature: .isForceUpdateAvailable)
      if !isForceUpdateAvailable {
        self.moduleOutput?.closeModuleAction()
        self.moduleOutput?.moduleClosed()
      }
    }
  }
}

// MARK: - Appearance

private extension ForceUpdateAppViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
  }
}
