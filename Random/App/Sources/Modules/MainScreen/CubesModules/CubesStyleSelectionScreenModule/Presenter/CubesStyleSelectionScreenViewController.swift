//
//  CubesStyleSelectionScreenViewController.swift
//  Random
//
//  Created by Сергей Юханов on 03.10.2023.
//

import UIKit

/// Презентер
final class CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenModule {

  // MARK: - Internal properties

  weak var moduleOutput: CubesStyleSelectionScreenModuleOutput?

  // MARK: - Private properties

  private let interactor: CubesStyleSelectionScreenInteractorInput
  private let moduleView: CubesStyleSelectionScreenViewProtocol
  private let factory: CubesStyleSelectionScreenFactoryInput

  // MARK: - Initialization

  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: CubesStyleSelectionScreenViewProtocol,
       interactor: CubesStyleSelectionScreenInteractorInput,
       factory: CubesStyleSelectionScreenFactoryInput) {
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
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationItem.largeTitleDisplayMode = .always
    navigationController?.navigationBar.prefersLargeTitles = true
  }

  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - CubesStyleSelectionScreenViewOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenViewOutput {
  func noPremiumAccessAction() {
    moduleOutput?.noPremiumAccessAction()
  }

  func didSelect(style: CubesStyleSelectionScreenModel.CubesStyle, with models: [CubesStyleSelectionScreenModel]) {
    interactor.saveCubesStyle(style, with: models)
    factory.createModelWith(selectStyle: style,
                            with: models,
                            isPremium: interactor.getIsPremium())
  }

  func didSelectStyleSuccessfully() {
    moduleOutput?.didSelectStyleSuccessfully()
  }
}

// MARK: - CubesStyleSelectionScreenInteractorOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenInteractorOutput {
  func didReceive(models: [CubesStyleSelectionScreenModel], isPremium: Bool) {
    factory.updateModels(models, isPremium: isPremium)
  }

  func didReceiveEmptyModelWith(isPremium: Bool) {
    factory.createInitialModelWith(isPremium: isPremium)
  }
}

// MARK: - CubesStyleSelectionScreenFactoryOutput

extension CubesStyleSelectionScreenViewController: CubesStyleSelectionScreenFactoryOutput {
  func didGenerated(models: [CubesStyleSelectionScreenModel]) {
    let cubesStyle = models.filter { $0.cubesStyleSelection }.first?.cubesStyle ?? .defaultStyle
    moduleView.updateContentWith(models: models)
    interactor.saveCubesStyle(cubesStyle, with: models)
  }
}

// MARK: - Private

private extension CubesStyleSelectionScreenViewController {
  func setupNavBar() {
    let appearance = Appearance()
    title = appearance.navBarTitle
  }
}

// MARK: - Appearance

private extension CubesStyleSelectionScreenViewController {
  struct Appearance {
    let navBarTitle = RandomStrings.Localizable.cubesStyle
  }
}
