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
  
  weak var moduleOutput: MoviesScreenModuleOutput?
  
  private let moduleView: MoviesScreenViewProtocol
  private let interactor: MoviesScreenInteractorInput
  private let factory: MoviesScreenFactoryInput
  
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
    
    navigationItem.largeTitleDisplayMode = .never
    title = "Фильмы"
  }
}

extension MoviesScreenViewController: MoviesScreenViewOutput {
  
}

extension MoviesScreenViewController: MoviesScreenInteractorOutput {
  
}

extension MoviesScreenViewController: MoviesScreenFactoryOutput {
  
}

extension MoviesScreenViewController {
  struct Appearance {
    
  }
}
