//
//  BottleStyleSelectionViewController.swift
//  Random
//
//  Created by Artem Pavlov on 16.08.2023.
//

import UIKit

/// Презентер
final class BottleStyleSelectionViewController: BottleStyleSelectionModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: BottleStyleSelectionModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: BottleStyleSelectionInteractorInput
  private let moduleView: BottleStyleSelectionViewProtocol
  private let factory: BottleStyleSelectionFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: BottleStyleSelectionViewProtocol,
       interactor: BottleStyleSelectionInteractorInput,
       factory: BottleStyleSelectionFactoryInput) {
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

// MARK: - BottleStyleSelectionViewOutput

extension BottleStyleSelectionViewController: BottleStyleSelectionViewOutput {}

// MARK: - BottleStyleSelectionInteractorOutput

extension BottleStyleSelectionViewController: BottleStyleSelectionInteractorOutput {}

// MARK: - BottleStyleSelectionFactoryOutput

extension BottleStyleSelectionViewController: BottleStyleSelectionFactoryOutput {}

// MARK: - Private

private extension BottleStyleSelectionViewController {
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

private extension BottleStyleSelectionViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
