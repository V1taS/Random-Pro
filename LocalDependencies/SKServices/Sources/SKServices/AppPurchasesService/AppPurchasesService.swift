//
//  AppPurchasesService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApphudSDK
import SKAbstractions
import StoreKit

public final class AppPurchasesService: IAppPurchasesService {

  // MARK: - Private properties

  private var cacheProducts: [ApphudProduct] = []

  // MARK: - Singleton

  public static let shared = AppPurchasesService()

  // Приватный инициализатор для предотвращения создания других экземпляров
  private init() {}

  // MARK: - Internal func

  @MainActor
  public func restorePurchase() async -> Bool {
    await Apphud.restorePurchases()
    return await isValidatePurchase()
  }

  @MainActor
  public func purchaseWith(
    _ productIdentifiers: String,
    completion: @escaping (
      SKAbstractions.AppPurchasesServiceState
    ) -> Void
  ) {
    let products = cacheProducts.filter { $0.productId == productIdentifiers }
    guard let product = products.first else {
      completion(.somethingWentWrong)
      return
    }

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

  @MainActor
  public func getProducts(completion: @escaping ([SKProduct]) -> Void) {
    Apphud.paywallsDidLoadCallback { [weak self] paywalls in
      if let paywall = paywalls.first(where: { $0.identifier == PremiumScreenPaywallIdentifier.paywallID }) {
        let products = paywall.products
        self?.cacheProducts = products
        let skProducts = products.compactMap {
          return $0.skProduct
        }
        DispatchQueue.main.async {
          completion(skProducts)
        }
      } else {
        completion([])
      }
    }
  }

  private func isValidatePurchase() async -> Bool {
    let isSubscription = Apphud.hasActiveSubscription()
    let isNonRenewingPurchase = await Apphud.isNonRenewingPurchaseActive(
      productIdentifier: PremiumScreenPurchaseType.lifetime.productIdentifiers
    )
    let isNonRenewingPurchaseSale = await Apphud.isNonRenewingPurchaseActive(
      productIdentifier: PremiumScreenPurchaseType.lifetimeSale.productIdentifiers
    )
    return isSubscription || isNonRenewingPurchase || isNonRenewingPurchaseSale
  }
}
