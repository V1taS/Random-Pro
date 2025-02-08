//
//  AppPurchasesService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import Foundation
import StoreKit

public protocol IAppPurchasesService {

  /// Получить доступные продукты
  /// - Parameter completion: Возвращает список продуктов
  func getProducts(completion: @escaping ([SKProduct]) -> Void)

  /// Делаем покупку продукта
  /// - Parameters:
  ///  - product: Продукт для покупки
  ///  - completion: Возвращает статус покупки
  func purchaseWith(
    _ productIdentifiers: String,
    completion: @escaping (AppPurchasesServiceState) -> Void
  )

  /// Восстановить покупки
  /// - Parameter completion: Возвращает результат валидации
  func restorePurchase() async -> Bool
}
