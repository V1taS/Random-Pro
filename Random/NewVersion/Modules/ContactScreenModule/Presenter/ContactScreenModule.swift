//
//  ContactScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol ContactScreenModuleOutput: AnyObject {
  
  /// Кнопка настройки была нажата
  func settingButtonAction()
}

protocol ContactScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: ContactScreenModuleOutput? { get set }
}

typealias ContactScreenModule = UIViewController & ContactScreenModuleInput

final class ContactScreenViewController: ContactScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: ContactScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: ContactScreenViewProtocol
  private let interactor: ContactScreenInteractorInput
  private let factory: ContactScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: ContactScreenViewProtocol,
       interactor: ContactScreenInteractorInput,
       factory: ContactScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationBar()
  }
  
  // MARK: - Private func
  
  private func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc private func settingButtonAction() {
    moduleOutput?.settingButtonAction()
  }
}

// MARK: - ContactScreenViewOutput

extension ContactScreenViewController: ContactScreenViewOutput {}

// MARK: - ContactScreenInteractorOutput

extension ContactScreenViewController: ContactScreenInteractorOutput {}

// MARK: - ContactScreenFactoryOutput

extension ContactScreenViewController: ContactScreenFactoryOutput {}

// MARK: - Appearance

extension ContactScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = NSLocalizedString("Контакты", comment: "")
  }
}
