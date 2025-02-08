//
//  PremiumScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import StoreKit
import SKAbstractions

/// События которые отправляем из Interactor в Presenter
protocol PremiumScreenInteractorOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: Результат генерации для таблички
  func didReceive(models: [SKProduct])
  
  /// Покупка восстановлена
  func didReceiveRestoredSuccess()
  
  /// Успешная покупка подписки
  func didReceiveSubscriptionPurchaseSuccess()
  
  /// Успешная разовая покупка
  func didReceiveOneTimePurchaseSuccess()
  
  /// Начало оплаты
  func startPaymentProcessing()
  
  /// Конец оплаты
  func stopPaymentProcessing()
  
  /// Обновить секции на главном экране
  func updateStateForSections()
  
  /// Что-то пошло не так
  func somethingWentWrong()
  
  /// Покупки отсутствуют
  func didReceivePurchasesMissing()
}

/// События которые отправляем от Presenter к Interactor
protocol PremiumScreenInteractorInput {
  
  /// Получить продукт от Аппл
  func getProducts()
  
  /// Основная кнопка была нажата
  /// - Parameter purchaseType: Тип платной услуги
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType)
  
  /// Восстановить покупки
  func restorePurchase()
}

/// Интерактор
final class PremiumScreenInteractor: PremiumScreenInteractorInput {
  
  // MARK: - Internal properties
  
  weak var output: PremiumScreenInteractorOutput?
  
  // MARK: - Private properties
  
  private let appPurchasesService: IAppPurchasesService
  private var cacheProducts: [SKProduct] = []
  private var storageService: StorageService
  private var mainScreenModel: MainScreenModel? {
    get {
      storageService.getData(from: MainScreenModel.self)
    } set {
      storageService.saveData(newValue)
    }
  }
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - appPurchasesService: Сервис работы с подписками
  ///  - services: Сервисы приложения
  init(_ appPurchasesService: IAppPurchasesService,
       services: ApplicationServices) {
    self.appPurchasesService = appPurchasesService
    storageService = services.storageService
  }
  
  // MARK: - Internal func
  
  func restorePurchase() {
    output?.startPaymentProcessing()

    Task { [weak self] in
      guard let self else { return }
      let isValidate = await appPurchasesService.restorePurchase()
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        output?.stopPaymentProcessing()

        switch isValidate {
        case true:
          output?.didReceiveRestoredSuccess()
          activatePremium()
        case false:
          output?.didReceivePurchasesMissing()
        }
      }
    }
  }
  
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    output?.startPaymentProcessing()
    
    let products = cacheProducts.filter { $0.productIdentifier == purchaseType.productIdentifiers }
    guard let product = products.first else {
      output?.somethingWentWrong()
      output?.stopPaymentProcessing()
      return
    }

    appPurchasesService.purchaseWith(product.productIdentifier) { [weak self] result in
      switch result {
      case .successfulSubscriptionPurchase:
        self?.output?.didReceiveSubscriptionPurchaseSuccess()
        self?.activatePremium()
      case .successfulOneTimePurchase:
        self?.output?.didReceiveOneTimePurchaseSuccess()
        self?.activatePremium()
      case .somethingWentWrong:
        self?.output?.somethingWentWrong()
      }
      self?.output?.stopPaymentProcessing()
    }
  }
  
  func getProducts() {
    appPurchasesService.getProducts { [weak self] products in
      self?.cacheProducts = products
      self?.output?.didReceive(models: products)
    }
  }
}

// MARK: - Private

private extension PremiumScreenInteractor {
  func activatePremium() {
    if let mainScreenModel {
      UserDefaults.standard.set(true, forKey: SecretsAPI.userPremiumKey)
      let newModel = MainScreenModel(isDarkMode: mainScreenModel.isDarkMode,
                                     isPremium: true,
                                     allSections: mainScreenModel.allSections)
      self.mainScreenModel = newModel
      output?.updateStateForSections()
    }
  }
}

// MARK: - Appearance

private extension PremiumScreenInteractor {
  struct Appearance {}
}
