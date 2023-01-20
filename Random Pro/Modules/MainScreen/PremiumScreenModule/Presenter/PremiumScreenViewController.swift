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
  /// - Parameter isModalPresentation: Открывается экран снизу вверх
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool)
  
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
  private var cacheIsModalPresentation = false
  
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
    factory.createMainButtonTitleFrom(.monthly,
                                      amount: "$ 2.55")
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()
  }
  
  // MARK: - Internal func
  
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool) {
    cacheIsModalPresentation = isModalPresentation
  }
}

// MARK: - PremiumScreenViewOutput

extension PremiumScreenViewController: PremiumScreenViewOutput {
  func monthlySubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func annualSubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func lifetimeAccessCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func didChangePageAction() {
    // TODO: -
  }
}

// MARK: - PremiumScreenInteractorOutput

extension PremiumScreenViewController: PremiumScreenInteractorOutput {}

// MARK: - PremiumScreenFactoryOutput

extension PremiumScreenViewController: PremiumScreenFactoryOutput {
  func didReceiveMainButton(title: String?) {
    moduleView.updateButtonWith(title: title)
  }
  
  func didReceive(models: [PremiumScreenSectionType]) {
    moduleView.updateContentWith(models: models)
  }
}

// MARK: - Private

private extension PremiumScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    title = appearance.title
    
    if cacheIsModalPresentation {
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
