//
//  AppPurchasesServiceState.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 8.02.2025.
//

import Foundation

public enum AppPurchasesServiceState {

  /// Успешная покупка подписки
  case successfulSubscriptionPurchase

  /// Успешная разовая покупка
  case successfulOneTimePurchase

  /// Что-то пошло не так
  case somethingWentWrong
}
