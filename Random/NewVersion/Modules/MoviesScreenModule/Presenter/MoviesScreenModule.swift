//
//  MoviesScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 09.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol MoviesScreenModuleOutput: AnyObject {}

protocol MoviesScreenModuleInput {
  
  var moduleOutput: MoviesScreenModuleOutput? { get set }
}

typealias MoviesScreenModule = UIViewController & MoviesScreenModuleInput

final class MoviesScreenViewController: MoviesScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: MoviesScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: MoviesScreenViewProtocol
  private let interactor: MoviesScreenInteractorInput
  private let factory: MoviesScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - interactor: интерактор
  ///   - moduleView: вью
  ///   - factory: фабрика
  init(moduleView: MoviesScreenViewProtocol,
       interactor: MoviesScreenInteractor,
       factory: MoviesScreenFactory) {
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
    title = appearance.setTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(settingButtonAction))
  }
  
  @objc private func settingButtonAction() {}
}

// MARK: - MoviesScreenViewOutput

extension MoviesScreenViewController: MoviesScreenViewOutput {}

// MARK: - MoviesScreenInteractorOutput

extension MoviesScreenViewController: MoviesScreenInteractorOutput {}

// MARK: - MoviesScreenFactoryOutput

extension MoviesScreenViewController: MoviesScreenFactoryOutput {}

// MARK: - Appearance

extension MoviesScreenViewController {
  struct Appearance {
    let setTitle = NSLocalizedString("Фильмы", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
