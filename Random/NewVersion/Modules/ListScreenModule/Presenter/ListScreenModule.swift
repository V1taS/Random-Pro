//
//  ListScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol ListScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol ListScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в  `другой модуль`
  var moduleOutput: ListScreenModuleOutput? { get set }
}

/// Псевдоним протокола UIViewController & ListScreenModuleInput
typealias ListScreenModule = UIViewController & ListScreenModuleInput

final class ListScreenViewController: ListScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: ListScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: ListScreenViewProtocol
  private let interactor: ListScreenInteractorInput
  private let factory: ListScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: ListScreenViewProtocol,
       interactor: ListScreenInteractorInput,
       factory: ListScreenFactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  // MARK: - Internal func
  
  override func loadView() {
    super.loadView()
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private func
  
  private func setupNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingsButtonAction))
  }
  
  @objc private func settingsButtonAction() {}
}

// MARK: - ListScreenViewOutput

extension ListScreenViewController: ListScreenViewOutput {}

// MARK: - ListScreenInteractorOutput

extension ListScreenViewController: ListScreenInteractorOutput {}

// MARK: - ListScreenFactoryOutput

extension ListScreenViewController: ListScreenFactoryOutput {}

// MARK: - Appearance

extension ListScreenViewController {
  struct Appearance {
    let settingsButtonIcon = UIImage(systemName: "gear")
    let title = NSLocalizedString("Список", comment: "")
  }
}
