//
//  CoinStyleSelectionScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 19.09.2023.
//

import UIKit

/// Презентер
final class CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: CoinStyleSelectionScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: CoinStyleSelectionScreenInteractorInput
  private let moduleView: CoinStyleSelectionScreenViewProtocol
  private let factory: CoinStyleSelectionScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: CoinStyleSelectionScreenViewProtocol,
       interactor: CoinStyleSelectionScreenInteractorInput,
       factory: CoinStyleSelectionScreenFactoryInput) {
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
    setNavigationBar()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true

    Metrics.shared.track(event: .coinStyleScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .coinStyleScreenClose)
  }
}

// MARK: - CoinStyleSelectionScreenViewOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenViewOutput {
  func noPremiumAccessAction() {
    moduleOutput?.noPremiumAccessAction()
    Metrics.shared.track(event: .coinStyleScreenButtonNoPremiumAccessAction)
  }

  func didSelect(style: CoinStyleSelectionScreenModel.CoinStyle, with models: [CoinStyleSelectionScreenModel]) {
    interactor.saveCoinStyle(style, with: models)
    factory.createModelWith(selectStyle: style,
                            with: models,
                            isPremium: interactor.getIsPremium())
    Metrics.shared.track(
      event: .coinStyleScreenButtonDidSelectStyle,
      properties: ["style_eagle": style.coinSidesName.eagle]
    )
  }

  func didSelectStyleSuccessfully() {
    moduleOutput?.didSelectStyleSuccessfully()
    Metrics.shared.track(event: .coinStyleScreenButtonDidSelectStyleSuccessfully)
  }
}

// MARK: - CoinStyleSelectionScreenInteractorOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenInteractorOutput {
  func didReceive(models: [CoinStyleSelectionScreenModel], isPremium: Bool) {
    factory.updateModels(models, isPremium: isPremium)
  }

  func didReceiveEmptyModelWith(isPremium: Bool) {
    factory.createInitialModelWith(isPremium: isPremium)
  }
}

// MARK: - CoinStyleSelectionScreenFactoryOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenFactoryOutput {
  func didGenerated(models: [CoinStyleSelectionScreenModel]) {
    let coinStyle = models.filter { $0.coinStyleSelection }.first?.coinStyle ?? .defaultStyle
    moduleView.updateContentWith(models: models)
    interactor.saveCoinStyle(coinStyle, with: models)
  }
}

// MARK: - Private

private extension CoinStyleSelectionScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
  }
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.coinStyle
  }
}
