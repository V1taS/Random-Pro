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
    view.backgroundColor = .blue //удалить потом
    setNavigationBar()
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - CoinStyleSelectionScreenViewOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenViewOutput {}

// MARK: - CoinStyleSelectionScreenInteractorOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenInteractorOutput {}

// MARK: - CoinStyleSelectionScreenFactoryOutput

extension CoinStyleSelectionScreenViewController: CoinStyleSelectionScreenFactoryOutput {}

// MARK: - Private

private extension CoinStyleSelectionScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    let settingButton = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(settingButtonAction))
    navigationItem.rightBarButtonItems = [settingButton]
  }
  
  @objc
  func settingButtonAction() {
    // TODO: Добавить экшен
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension CoinStyleSelectionScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
