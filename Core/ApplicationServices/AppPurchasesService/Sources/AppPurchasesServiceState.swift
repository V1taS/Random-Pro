//
//  AppPurchasesServiceState.swift
//  AppPurchasesService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

enum AppPurchasesServiceState: AppPurchasesServiceStateProtocol {

  /// Успешная покупка подписки
  case successfulSubscriptionPurchase

  /// Успешная разовая покупка
  case successfulOneTimePurchase

  /// Что-то пошло не так
  case somethingWentWrong
}
