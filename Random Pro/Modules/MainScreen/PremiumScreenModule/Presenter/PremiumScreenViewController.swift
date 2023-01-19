//
//  PremiumScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PremiumScreenModuleOutput: AnyObject {
  
  /// Модуль был закрыт
  func closeButtonAction()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol PremiumScreenModuleInput {
  
  /// Выбрать способ показа экрана
  /// - Parameter type: Тип показа
  func selectPresentType(_ type: PremiumScreenPresentType)
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: PremiumScreenModuleOutput? { get set }
}

/// Готовый модуль `PremiumScreenModule`
typealias PremiumScreenModule = UIViewController & PremiumScreenModuleInput

/// Презентер
final class PremiumScreenViewController: PremiumScreenModule {

  // MARK: - Internal properties
  
  weak var moduleOutput: PremiumScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: PremiumScreenInteractorInput
  private let moduleView: PremiumScreenViewProtocol
  private let factory: PremiumScreenFactoryInput
  private var cacheIsPresent = false
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: PremiumScreenViewProtocol,
       interactor: PremiumScreenInteractorInput,
       factory: PremiumScreenFactoryInput) {
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
    
    factory.createListModelWith()
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()
  }
  
  // MARK: - Internal func
  
  func selectPresentType(_ type: PremiumScreenPresentType) {
    moduleView.selectPresentType(type)
    cacheIsPresent = type == .present
  }
}

// MARK: - PremiumScreenViewOutput

extension PremiumScreenViewController: PremiumScreenViewOutput {}

// MARK: - PremiumScreenInteractorOutput

extension PremiumScreenViewController: PremiumScreenInteractorOutput {}

// MARK: - PremiumScreenFactoryOutput

extension PremiumScreenViewController: PremiumScreenFactoryOutput {
  func didReceive(models: [PremiumScreenSectionType]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Private

private extension PremiumScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    if cacheIsPresent {
      let closeButton = UIBarButtonItem(image: appearance.closeButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(closeButtonAction))
      
      navigationItem.rightBarButtonItems = [closeButton]
    }
  }
  
  @objc
  func closeButtonAction() {
    moduleOutput?.closeButtonAction()
  }
}

// MARK: - Appearance

private extension PremiumScreenViewController {
  struct Appearance {
    let title = NSLocalizedString("Премиум", comment: "")
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
