//
//  BottleScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 29.11.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol BottleScreenModuleOutput: AnyObject {

  /// Была нажата кнопка (настройки)
  func settingButtonAction()

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

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    interactor.updateStyle()
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
  func didReceive(model: BottleScreenModel) {
    moduleView.resetPositionBottle()
    moduleView.updateContentWith(model: model)
  }
  
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
    navigationItem.rightBarButtonItems = [
      UIBarButtonItem(image: appearance.settingsButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(settingButtonAction)),
      UIBarButtonItem(image: appearance.resetButtonIcon,
                      style: .plain,
                      target: self,
                      action: #selector(resetButtonAction))
    ]
  }
  
  @objc
  func resetButtonAction() {
    moduleView.resetPositionBottle()
    interactor.stopHapticFeedback()
    impactFeedback.impactOccurred()
  }

  @objc
  func settingButtonAction() {
    moduleOutput?.settingButtonAction()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension BottleScreenViewController {
  struct Appearance {
    let setTitle = RandomStrings.Localizable.bottle
    let settingsButtonIcon = UIImage(systemName: "gear")
    let resetButtonIcon = UIImage(systemName: "arrow.counterclockwise")
  }
}
