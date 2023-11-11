//
//  AppPurchasesService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApphudSDK

protocol AppPurchasesService {
  
  /// Получить доступные продукты
  /// - Parameter completion: Возвращает список продуктов
  func getProducts(completion: @escaping ([ApphudProduct]?) -> Void)
  
  /// Делаем покупку продукта
  /// - Parameters:
  ///  - product: Продукт для покупки
  ///  - completion: Возвращает статус покупки
  func purchaseWith(_ product: ApphudProduct,
                    completion: @escaping (AppPurchasesServiceState) -> Void)
  
  /// Восстановить покупки
  /// - Parameter completion: Возвращает результат валидации
  func restorePurchase(completion: @escaping (_ isValidate: Bool) -> Void)
  
  /// Восстановить покупки
  /// - Parameter completion: Возвращает результат валидации
  func isValidatePurchase(completion: @escaping (_ isValidate: Bool) -> Void)
}

final class AppPurchasesServiceImpl: AppPurchasesService {
  
  // MARK: - Internal func
  
  func restorePurchase(completion: @escaping (_ isValidate: Bool) -> Void) {
    Apphud.restorePurchases { [weak self] _, _, _ in
      DispatchQueue.main.async {
        self?.isValidatePurchase(completion: completion)
      }
    }
  }
  
  func purchaseWith(_ product: ApphudProduct,
                    completion: @escaping (AppPurchasesServiceState) -> Void) {
    Apphud.purchase(product) { result in
      DispatchQueue.main.async {
        if let subscription = result.subscription, subscription.isActive() {
          completion(.successfulSubscriptionPurchase)
        } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
          completion(.successfulOneTimePurchase)
        } else {
          completion(.somethingWentWrong)
        }
      }
    }
  }
  
  func getProducts(completion: @escaping ([ApphudProduct]?) -> Void) {
    Apphud.paywallsDidLoadCallback { paywalls in
      if let paywall = paywalls.first(where: { $0.identifier == "PremiumAccess" }) {
        let products = paywall.products
        DispatchQueue.main.async {
          completion(products)
        }
      }
    }
  }
  
  func isValidatePurchase(completion: @escaping (_ isValidate: Bool) -> Void) {
    DispatchQueue.main.async {
      let isSubscription = Apphud.hasActiveSubscription()
      let isNonRenewingPurchase = Apphud.isNonRenewingPurchaseActive(
        productIdentifier: PremiumScreenPurchaseType.lifetime.productIdentifiers
      )
      let isNonRenewingPurchaseSale = Apphud.isNonRenewingPurchaseActive(
        productIdentifier: PremiumScreenPurchaseType.lifetimeSale.productIdentifiers
      )
      completion(isSubscription || isNonRenewingPurchase || isNonRenewingPurchaseSale)
    }
  }
}
