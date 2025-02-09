//
//  PremiumScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import StoreKit
import FancyUIKit
import FancyStyle
import SKAbstractions

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
  
  /// Установить распродажу
  func setLifetimeSale(_ value: Bool)
  
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
  private var isLifetimeSale = false
  private var cacheModels: [SKProduct] = []
  
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
    
    factory.createListModelWith(models: [], isLifetimeSale: isLifetimeSale)
    navigationItem.largeTitleDisplayMode = .never
    setNavigationBar()

    Metrics.shared.track(event: .premiumScreenOpen)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    interactor.getProducts()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .premiumScreenClose)
  }
  
  // MARK: - Internal func
  
  func setLifetimeSale(_ value: Bool) {
    let lifetimeSaleProduct = cacheModels.filter {
      $0.productIdentifier == PremiumScreenPurchaseType.lifetimeSale.productIdentifiers
    }.first
    isLifetimeSale = value
  }
  
  func selectIsModalPresentationStyle(_ isModalPresentation: Bool) {
    cacheIsModalPresentation = isModalPresentation
  }
}

// MARK: - PremiumScreenViewOutput

extension PremiumScreenViewController: PremiumScreenViewOutput {
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    interactor.mainButtonAction(purchaseType)
    Metrics.shared.track(
      event: .premiumScreenButtonPurchaseAction,
      properties: ["purchaseType": purchaseType.productIdentifiers]
    )
  }
  
  func restorePurchaseButtonAction() {
    interactor.restorePurchase()
    Metrics.shared.track(event: .premiumScreenButtonRestorePurchase)
  }
  
  func didChangePageAction() {
    // TODO: -
  }
  
  func monthlySubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
    Metrics.shared.track(event: .premiumScreenMonthlySubscriptionCardSelected)
  }
  
  func annualSubscriptionCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
    Metrics.shared.track(event: .premiumScreenAnnualSubscriptionCardSelected)
  }
  
  func lifetimeAccessCardSelected(_ purchaseType: PremiumScreenPurchaseType, amount: String?) {
    factory.createMainButtonTitleFrom(purchaseType, amount: amount)
    Metrics.shared.track(event: .premiumScreenLifetimeAccessCardSelected)
  }
}

// MARK: - PremiumScreenInteractorOutput

extension PremiumScreenViewController: PremiumScreenInteractorOutput {
  func didReceiveSubscriptionPurchaseSuccess() {
    moduleOutput?.didReceiveSubscriptionPurchaseSuccess()
    Metrics.shared.track(event: .premiumScreenDidReceiveSubscriptionPurchaseSuccess)
  }

  func didReceiveOneTimePurchaseSuccess() {
    moduleOutput?.didReceiveOneTimePurchaseSuccess()
    Metrics.shared.track(event: .premiumScreenDidReceiveOneTimePurchaseSuccess)
  }

  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
    Metrics.shared.track(event: .premiumScreenSomethingWentWrong)
  }

  func didReceivePurchasesMissing() {
    moduleOutput?.didReceivePurchasesMissing()
    Metrics.shared.track(event: .premiumScreenDidReceivePurchasesMissing)
  }

  func updateStateForSections() {
    moduleOutput?.updateStateForSections()
  }
  
  func didReceiveRestoredSuccess() {
    moduleOutput?.didReceiveRestoredSuccess()
    Metrics.shared.track(event: .premiumScreenDidReceiveRestoredSuccess)
  }
  
  func startPaymentProcessing() {
    moduleView.startLoader()
    Metrics.shared.track(event: .premiumScreenStartPaymentProcessing)
  }
  
  func stopPaymentProcessing() {
    moduleView.stopLoader()
    Metrics.shared.track(event: .premiumScreenStopPaymentProcessing)
  }
  
  func didReceive(models: [SKProduct]) {
    cacheModels = models
    factory.createListModelWith(models: models, isLifetimeSale: isLifetimeSale)
    
    if isLifetimeSale {
      let lifetimeSaleProduct = models.filter {
        $0.productIdentifier == PremiumScreenPurchaseType.lifetimeSale.productIdentifiers
      }.first
      factory.createMainButtonTitleFrom(.lifetime, amount: lifetimeSaleProduct?.localizedPrice)
    }
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

// MARK: - SKProduct

private extension SKProduct {
  var localizedPrice: String? {
    let numberFormatter = NumberFormatter()
    numberFormatter.locale = priceLocale
    numberFormatter.numberStyle = .currency
    return numberFormatter.string(from: price)
  }
}

// MARK: - Appearance

private extension PremiumScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.premium
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
