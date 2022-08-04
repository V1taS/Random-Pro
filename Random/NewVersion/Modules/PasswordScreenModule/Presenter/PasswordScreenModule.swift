//
//  PasswordScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 04.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol PasswordScreenModuleOutput: AnyObject {
  
}

protocol PasswordScreenModuleInput: AnyObject {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: PasswordScreenModuleOutput? { get set }
}

typealias PasswordScreenModule = UIViewController & PasswordScreenModuleInput

final class PasswordScreenViewController: PasswordScreenModule {
  
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
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar()
  }
  
  
  // MARK: - Private func
  
  private func navigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
//    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
//                                                        style: .plain,
//                                                        target: self,
//                                                        action: #selector(cleanButtonAction))
  }
  
  @objc private func cleanButtonAction() {
    
  }
}

extension PasswordScreenViewController: PasswordScreenViewOutput {
  
}

extension PasswordScreenViewController: PasswordScreenFactoryOutput {
  
}

extension PasswordScreenViewController: PasswordScreenInteractorOutput {
  
}

// MARK: - Appearance

private extension PasswordScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Пароли", comment: "")
    let settingsButtonIcon = UIImage(systemName: "clean")
  }
}
