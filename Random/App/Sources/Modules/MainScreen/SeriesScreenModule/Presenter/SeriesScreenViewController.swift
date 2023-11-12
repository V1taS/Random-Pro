//
//  SeriesScreenViewController.swift
//  Random
//
//  Created by Артем Павлов on 13.11.2023.
//

import UIKit

/// Презентер
final class SeriesScreenViewController: SeriesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SeriesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SeriesScreenInteractorInput
  private let moduleView: SeriesScreenViewProtocol
  private let factory: SeriesScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: SeriesScreenViewProtocol,
       interactor: SeriesScreenInteractorInput,
       factory: SeriesScreenFactoryInput) {
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
   // moduleOutput?.moduleClosed()
  }
}

// MARK: - SeriesScreenViewOutput

extension SeriesScreenViewController: SeriesScreenViewOutput {}

// MARK: - SeriesScreenInteractorOutput

extension SeriesScreenViewController: SeriesScreenInteractorOutput {}

// MARK: - SeriesScreenFactoryOutput

extension SeriesScreenViewController: SeriesScreenFactoryOutput {}

// MARK: - Private

private extension SeriesScreenViewController {
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

private extension SeriesScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
