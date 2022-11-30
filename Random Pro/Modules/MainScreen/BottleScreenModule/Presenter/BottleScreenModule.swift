//
//  BottleScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol BottleScreenModuleOutput: AnyObject {
  
}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol BottleScreenModuleInput {
  
  var moduleOutput: BottleScreenModuleOutput? { get set }
}

typealias BottleScreenModule = UIViewController & BottleScreenModuleInput

final class BottleScreenViewController: BottleScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: BottleScreenModuleOutput?
  
  // MARK: - Private property
  
  private let moduleView: BottleScreenViewProtocol
  private let interactor: BottleScreenInteractorInput
  private let factory: BottleScreenFactoryInput
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: BottleScreenViewProtocol,
       interactor: BottleScreenInteractorInput,
       factory: BottleScreenFactoryInput) {
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
  
  @objc private func settingButtonAction() {
    
  }
}

// MARK: - BottleScreenViewOutput

extension BottleScreenViewController: BottleScreenViewOutput {
  func generateButtonAction() {
    
  }
}

// MARK: - BottleScreenInteractorOutput

extension BottleScreenViewController: BottleScreenInteractorOutput {
  
}

// MARK: - BottleScreenFactoryOutput

extension BottleScreenViewController: BottleScreenFactoryOutput {
  
}

extension BottleScreenViewController {
  struct Appearance {
    let setTitle = NSLocalizedString("Бутылочка", comment: "")
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
