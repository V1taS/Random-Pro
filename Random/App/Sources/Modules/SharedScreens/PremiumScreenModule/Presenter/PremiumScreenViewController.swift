//
//  PremiumScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import StoreKit
import RandomUIKit

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol PremiumScreenModuleOutput: AnyObject {

  /// Покупка восстановлена
  func didReceiveRestoredSuccess()

  /// Успешная покупка подписки
  func didReceiveSubscriptionPurchaseSuccess()

  /// Успешная разовая покупка
  func didReceiveOneTimePurchaseSuccess()

  /// Обновить секции на главном экране
  func updateStateForSections()

  /// Что-то пошло не так
  func somethingWentWrong()

  /// Покупки отсутствуют
  func didReceivePurchasesMissing()
  
  /// Модуль был закрыт
  func closeButtonAction()
  
  /// Модуль был закрыт
  func moduleClosed()
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
typealias PremiumScreenModule = ViewController & PremiumScreenModuleInput

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
    
    factory.createListModelWith(models: [])
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor.getProducts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    moduleOutput?.moduleClosed()
  }
  
  // MARK: - Internal func
  
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool) {
    cacheIsModalPresentation = isModalPresentation
  }
}

// MARK: - PremiumScreenViewOutput

extension PremiumScreenViewController: PremiumScreenViewOutput {
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    interactor.mainButtonAction(purchaseType)
  }
  
  func restorePurchaseButtonAction() {
    interactor.restorePurchase()
  }
  
  func didChangePageAction() {
    // TODO: -
  }
  
  func monthlySubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func annualSubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
  
  func lifetimeAccessCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
  }
}

// MARK: - PremiumScreenInteractorOutput

extension PremiumScreenViewController: PremiumScreenInteractorOutput {
  func didReceiveSubscriptionPurchaseSuccess() {
    moduleOutput?.didReceiveSubscriptionPurchaseSuccess()
  }

  func didReceiveOneTimePurchaseSuccess() {
    moduleOutput?.didReceiveOneTimePurchaseSuccess()
  }

  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }

  func didReceivePurchasesMissing() {
    moduleOutput?.didReceivePurchasesMissing()
  }

  func updateStateForSections() {
    moduleOutput?.updateStateForSections()
  }
  
  func didReceiveRestoredSuccess() {
    moduleOutput?.didReceiveRestoredSuccess()
  }
  
  func startPaymentProcessing() {
    moduleView.startLoader()
  }
  
  func stopPaymentProcessing() {
    moduleView.stopLoader()
  }
  
  func didReceive(models: [SKProduct]) {
    factory.createListModelWith(models: models)
  }
}

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
    let title = RandomStrings.Localizable.premium
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
