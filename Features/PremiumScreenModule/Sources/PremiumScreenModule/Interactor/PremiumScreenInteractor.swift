//
//  PremiumScreenInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import UIKit
import StoreKit
import ApplicationInterface

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
  
  /// Обновить главный экран
  /// - Parameter isPremium: Премиум включен
  func updateMainScreenWith(isPremium: Bool)
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
  
  private let appPurchasesService: AppPurchasesServiceProtocol
  private var cacheProducts: [ApphudProductProtocol] = []
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///  - appPurchasesService: Сервис работы с подписками
  init(appPurchasesService: AppPurchasesServiceProtocol) {
    self.appPurchasesService = appPurchasesService
  }
  
  // MARK: - Internal func
  
  func restorePurchase() {
    output?.startPaymentProcessing()
    appPurchasesService.restorePurchase { [weak self] isValidate in
      self?.output?.stopPaymentProcessing()
      
      switch isValidate {
      case true:
        self?.output?.didReceiveRestoredSuccess()
        self?.activatePremium()
      case false:
        self?.output?.didReceivePurchasesMissing()
      }
    }
  }
  
  func mainButtonAction(_ purchaseType: PremiumScreenPurchaseType) {
    output?.startPaymentProcessing()
    
    let products = cacheProducts.filter { $0.productId == purchaseType.productIdentifiers }
    guard let product = products.first else {
      output?.somethingWentWrong()
      output?.stopPaymentProcessing()
      return
    }

    appPurchasesService.purchaseWith(product) { [weak self] result in
      guard let purchaseState = result as? PremiumScreenPurchaseState else {
        return
      }
      switch purchaseState {
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
      if let products {
        self?.cacheProducts = products
        
        let skProducts = products.compactMap {
          return $0.skProduct
        }
        self?.output?.didReceive(models: skProducts)
      } else {
        self?.output?.somethingWentWrong()
      }
    }
  }
}

// MARK: - Private

private extension PremiumScreenInteractor {
  func activatePremium() {
    output?.updateStateForSections()
    output?.updateMainScreenWith(isPremium: true)
  }
}

// MARK: - Appearance

private extension PremiumScreenInteractor {
  struct Appearance {}
}
