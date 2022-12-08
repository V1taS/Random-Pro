//
//  BottleScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в  `другой модуль`
protocol BottleScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в  `текущий модуль`
protocol BottleScreenModuleInput {
  
  var moduleOutput: BottleScreenModuleOutput? { get set }
}

typealias BottleScreenModule = UIViewController & BottleScreenModuleInput

final class BottleScreenViewController: BottleScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: BottleScreenModuleOutput?
  
  // MARK: - Private properties
  
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
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
  }
}

// MARK: - Private

private extension BottleScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.setTitle
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(resetButtonAction))
  }
  
  @objc
  func resetButtonAction() {
    moduleView.resetPositionBottle()
  }
}

// MARK: - BottleScreenViewOutput

extension BottleScreenViewController: BottleScreenViewOutput {
  
  func bottleRotationButtonAction() {
    interactor.generatesBottleRotationTimeAction()
  }
}

// MARK: - BottleScreenInteractorOutput

extension BottleScreenViewController: BottleScreenInteractorOutput {
  func tactileFeedbackBottleRotates() {
    moduleView.tactileFeedbackBottleRotates()
  }
  
  func stopBottleRotation() {
    moduleView.stopBottleRotation()
  }
}

// MARK: - BottleScreenFactoryOutput

extension BottleScreenViewController: BottleScreenFactoryOutput {}

extension BottleScreenViewController {
  struct Appearance {
    let setTitle = NSLocalizedString("Бутылочка", comment: "")
    let settingsButtonIcon = UIImage(systemName: "arrow.counterclockwise")
  }
}
