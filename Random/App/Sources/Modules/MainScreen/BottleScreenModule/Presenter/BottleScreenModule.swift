//
//  BottleScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol BottleScreenModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol BottleScreenModuleInput {
  
  var moduleOutput: BottleScreenModuleOutput? { get set }
}

typealias BottleScreenModule = ViewController & BottleScreenModuleInput

final class BottleScreenViewController: BottleScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: BottleScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let moduleView: BottleScreenViewProtocol
  private let interactor: BottleScreenInteractorInput
  private let factory: BottleScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
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
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - BottleScreenViewOutput

extension BottleScreenViewController: BottleScreenViewOutput {
  
  func bottleRotationButtonAction() {
    interactor.generatesBottleRotationTimeAction()
    interactor.playHapticFeedback()
  }
}

// MARK: - BottleScreenInteractorOutput

extension BottleScreenViewController: BottleScreenInteractorOutput {
  func stopBottleRotation() {
    moduleView.stopBottleRotation()
    interactor.stopHapticFeedback()
  }
}

// MARK: - BottleScreenFactoryOutput

extension BottleScreenViewController: BottleScreenFactoryOutput {}

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
    interactor.stopHapticFeedback()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension BottleScreenViewController {
  struct Appearance {
    let setTitle = RandomStrings.Localizable.bottle
    let settingsButtonIcon = UIImage(systemName: "arrow.counterclockwise")
  }
}
