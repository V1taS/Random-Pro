//
//  AppPurchasesService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApphudSDK

public final class AppPurchasesServiceImpl: AppPurchasesServiceProtocol {
  
  // MARK: - Public func
  
  public init() {}
  
  // MARK: - Public func
  
  public func getProducts(completion: @escaping ([ApphudProductProtocol]?) -> Void) {
    Apphud.paywalls.map { (paywalls) in
      DispatchQueue.main.async {
        let paywall = paywalls.first(where: { $0.identifier == "PremiumAccess" })
        let products = paywall?.products.map {
          return ApphudProductModel(productId: $0.productId,
                                    name: $0.name,
                                    store: $0.store,
                                    skProduct: $0.skProduct,
                                    paywallIdentifier: $0.paywallIdentifier)
        }
        completion(products)
      }
    }
  }
  
  public func purchaseWith(_ product: ApphudProductProtocol,
                           completion: @escaping (AppPurchasesServiceStateProtocol) -> Void) {
    let product = ApphudProductDecodeModel(productId: product.productId,
                                           name: product.name,
                                           store: product.store,
                                           id: product.paywallIdentifier)
    let encoder = JSONEncoder()
    let productData = (try? encoder.encode(product)) ?? Data()
    let decoder = JSONDecoder()
    let apphudProduct = try? decoder.decode(ApphudProduct.self, from: productData)
    
    guard let apphudProduct else {
      return
    }
    
    Apphud.purchase(apphudProduct) { result in
      DispatchQueue.main.async {
        if let subscription = result.subscription, subscription.isActive() {
          completion(AppPurchasesServiceState.successfulSubscriptionPurchase)
        } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
          completion(AppPurchasesServiceState.successfulOneTimePurchase)
        } else {
          completion(AppPurchasesServiceState.somethingWentWrong)
        }
      }
    }
  }
  
  public func restorePurchase(completion: @escaping (Bool) -> Void) {
    Apphud.restorePurchases { [weak self] _, _, _ in
      DispatchQueue.main.async {
        self?.isValidatePurchase(completion: completion)
      }
    }
  }
  
  public func isValidatePurchase(completion: @escaping (Bool) -> Void) {
    DispatchQueue.main.async {
      let isSubscription = Apphud.hasActiveSubscription()
      let isNonRenewingPurchase = Apphud.isNonRenewingPurchaseActive(
        productIdentifier: Appearance().lifetimeProductIdentifiers
      )
      completion(isSubscription || isNonRenewingPurchase)
    }
  }
}

// MARK: - Appearance

private extension AppPurchasesServiceImpl {
  struct Appearance {
    let lifetimeProductIdentifiers = "com.sosinvitalii.Random.OneTimePurchasePremiumAccess"
  }
}
