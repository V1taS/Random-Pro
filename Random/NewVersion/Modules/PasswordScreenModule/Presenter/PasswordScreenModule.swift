//
//  PasswordScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 04.08.2022.
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
    navigationItem.largeTitleDisplayMode = .never
    title = "Пароли"
  }
  
}

extension PasswordScreenViewController: PasswordScreenViewOutput {
  
}

extension PasswordScreenViewController: PasswordScreenFactoryOutput {
  
}

extension PasswordScreenViewController: PasswordScreenInteractorOutput {
  
}
