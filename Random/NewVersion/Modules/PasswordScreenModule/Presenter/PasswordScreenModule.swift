//
//  PasswordScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol PasswordScreenModuleOutput: AnyObject {}

protocol PasswordScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: PasswordScreenModuleOutput? { get set }
}

typealias PasswordScreenModule = UIViewController & PasswordScreenModuleInput

final class PasswordScreenViewController: PasswordScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: PasswordScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: PasswordScreenViewProtocol
  private let interactor: PasswordScreenInteractorInput
  private let factory: PasswordScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: PasswordScreenViewProtocol,
       interactor: PasswordScreenInteractorInput,
       factory: PasswordScreenFactoryInput) {
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
    interactor.getContent()
  }
  
  // MARK: - Private func
  
  private func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
  }
  
  @objc private func cleanButtonAction() {}
}

// MARK: - PasswordScreenViewOutput

extension PasswordScreenViewController: PasswordScreenViewOutput {}

// MARK: - PasswordScreenFactoryOutput

extension PasswordScreenViewController: PasswordScreenFactoryOutput {}

// MARK: - PasswordScreenInteractorOutput

extension PasswordScreenViewController: PasswordScreenInteractorOutput {}

// MARK: - Appearance

private extension PasswordScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Пароли", comment: "")
    let settingsButtonIcon = UIImage(systemName: "clean")
  }
}
