//
//  RockPaperScissorsScreenModule.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 12.12.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol RockPaperScissorsScreenModuleOutput: AnyObject {}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol RockPaperScissorsScreenModuleInput {
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: RockPaperScissorsScreenModuleOutput? { get set }
}

typealias RockPaperScissorsScreenModule = UIViewController & RockPaperScissorsScreenModuleInput

final class RockPaperScissorsScreenViewController: RockPaperScissorsScreenModule {
  
  // MARK: - Internal property
  
  weak var moduleOutput: RockPaperScissorsScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let moduleView: RockPaperScissorsScreenViewProtocol
  private let interactor: RockPaperScissorsScreenInteractorInput
  private let factory: RockPaperScissorsScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: RockPaperScissorsScreenViewProtocol,
       interactor: RockPaperScissorsScreenInteractorInput,
       factory: RockPaperScissorsScreenFactoryInput) {
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
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationBar()
    interactor.getContent()
  }
}

// MARK: - RockPaperScissorsScreenViewOutput

extension RockPaperScissorsScreenViewController: RockPaperScissorsScreenViewOutput {
  func resetGeneration() {
    factory.generateEmptyModel()
  }
  
  func generateButtonAction() {
    interactor.getContent()
  }
}

// MARK: - RockPaperScissorsScreenInteractorOutput

extension RockPaperScissorsScreenViewController: RockPaperScissorsScreenInteractorOutput {
  func didReceive(model: RockPaperScissorsScreenModel) {
    factory.generate(model: model)
  }
  
  func createStartModel() {
    factory.generateEmptyModel()
  }
}

// MARK: - RockPaperScissorsScreenFactoryOutput

extension RockPaperScissorsScreenViewController: RockPaperScissorsScreenFactoryOutput {
  func didReceiveGenerate(model: RockPaperScissorsScreenModel) {
    moduleView.updateContentWith(model: model)
    interactor.saveModel(model: model)
  }
}

// MARK: - Private

private extension RockPaperScissorsScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.resetButtonIcon,
                                                        style: .plain,
                                                        target: self,
                                                        action: #selector(resetButtonAction))
  }
  
  @objc func resetButtonAction() {
    moduleView.resetGeneration()
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension RockPaperScissorsScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Цу-е-фа", comment: "")
    let resetButtonIcon = UIImage(systemName: "arrow.counterclockwise")
  }
}
