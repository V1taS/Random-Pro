//
//  BottleStyleSelectionScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit

/// Презентер
final class BottleStyleSelectionScreenViewController: BottleStyleSelectionScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: BottleStyleSelectionScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: BottleStyleSelectionScreenInteractorInput
  private let moduleView: BottleStyleSelectionScreenViewProtocol
  private let factory: BottleStyleSelectionScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: BottleStyleSelectionScreenViewProtocol,
       interactor: BottleStyleSelectionScreenInteractorInput,
       factory: BottleStyleSelectionScreenFactoryInput) {
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

    interactor.getContent()
    setupNavBar()

    Metrics.shared.track(event: .bottleStyleScreenOpen)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()

    Metrics.shared.track(event: .bottleStyleScreenClose)
  }
}

// MARK: - BottleStyleSelectionScreenViewOutput

extension BottleStyleSelectionScreenViewController: BottleStyleSelectionScreenViewOutput {
  func noPremiumAccessAction() {
    moduleOutput?.noPremiumAccessAction()

    Metrics.shared.track(event: .bottleStyleScreenButtonNoPremiumAccessAction)
  }

  func didSelect(style: BottleStyleSelectionScreenModel.BottleStyle, with models: [BottleStyleSelectionScreenModel]) {
    interactor.saveBottleStyle(style, with: models)
    factory.createModelWith(selectStyle: style,
                            with: models,
                            isPremium: interactor.getIsPremium())
    Metrics.shared.track(
      event: .bottleStyleScreenButtonDidSelectStyle,
      properties: ["style": style.rawValue]
    )
  }

  func didSelectStyleSuccessfully() {
    moduleOutput?.didSelectStyleSuccessfully()
    Metrics.shared.track(event: .bottleStyleScreenButtonDidSelectStyleSuccessfully)
  }
}

// MARK: - BottleStyleSelectionScreenInteractorOutput

extension BottleStyleSelectionScreenViewController: BottleStyleSelectionScreenInteractorOutput {
  func didReceive(models: [BottleStyleSelectionScreenModel], isPremium: Bool) {
    factory.updateModels(models, isPremium: isPremium)
  }

  func didReceiveEmptyModelWith(isPremium: Bool) {
    factory.createInitialModelWith(isPremium: isPremium)
  }
}

// MARK: - BottleStyleSelectionScreenFactoryOutput

extension BottleStyleSelectionScreenViewController: BottleStyleSelectionScreenFactoryOutput {
  func didGenerated(models: [BottleStyleSelectionScreenModel]) {
    let bottleStyle = models.filter { $0.bottleStyleSelection }.first?.bottleStyle ?? .defaultStyle
    moduleView.updateContentWith(models: models)
    interactor.saveBottleStyle(bottleStyle, with: models)
  }
}

// MARK: - Private

private extension BottleStyleSelectionScreenViewController {

  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.navBarTitle
  }
}

// MARK: - Appearance

private extension BottleStyleSelectionScreenViewController {
  struct Appearance {
    let navBarTitle = RandomStrings.Localizable.bottleStyle
  }
}
