//
//  AppPurchasesService.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import StoreKit

// MARK: - AppPurchasesServiceProtocol

public protocol AppPurchasesServiceProtocol {
  
  /// Получить доступные продукты
  /// - Parameter completion: Возвращает список продуктов
  func getProducts(completion: @escaping ([ApphudProductProtocol]?) -> Void)
  
  /// Делаем покупку продукта
  /// - Parameters:
  ///  - product: Продукт для покупки
  ///  - completion: Возвращает статус покупки
  func purchaseWith(_ product: any ApphudProductProtocol,
                    completion: @escaping (AppPurchasesServiceStateProtocol) -> Void)
  
  /// Восстановить покупки
  /// - Parameter completion: Возвращает результат валидации
  func restorePurchase(completion: @escaping (_ isValidate: Bool) -> Void)
  
  /// Восстановить покупки
  /// - Parameter completion: Возвращает результат валидации
  func isValidatePurchase(completion: @escaping (_ isValidate: Bool) -> Void)
}

// MARK: - ApphudProductProtocol

public protocol ApphudProductProtocol {
  
  /// Product identifier from App Store Connect.
  var productId: String { get }
  
  /// Product name from Apphud Dashboard
  var name: String? { get }
  
  /// Always `app_store` in iOS SDK.
  var store: String { get }
  
  /**
   When paywalls are successfully loaded, skProduct model will always be present if App Store returned model for this product id. getPaywalls method will return callback only when StoreKit products are fetched and mapped with Apphud products.
   
   May be `nil` if product identifier is invalid, or product is not available in App Store Connect.
   */
  var skProduct: SKProduct? { get }
  
  /// Current product's paywall identifier, if available.
  var paywallIdentifier: String? { get }
}

// MARK: - AppPurchasesServiceStateProtocol

public protocol AppPurchasesServiceStateProtocol {
  
  /// Успешная покупка подписки
  static var successfulSubscriptionPurchase: Self { get }
  
  /// Успешная разовая покупка
  static var successfulOneTimePurchase: Self { get }
  
  /// Что-то пошло не так
  static var somethingWentWrong: Self { get }
}
