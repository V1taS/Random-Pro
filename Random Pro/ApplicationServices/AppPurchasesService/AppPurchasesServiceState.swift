//
//  AppPurchasesServiceState.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 23.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum AppPurchasesServiceState {

  /// Успешная покупка подписки
  case successfulSubscriptionPurchase

  /// Успешная разовая покупка
  case successfulOneTimePurchase

  /// Что-то пошло не так
  case somethingWentWrong
}
