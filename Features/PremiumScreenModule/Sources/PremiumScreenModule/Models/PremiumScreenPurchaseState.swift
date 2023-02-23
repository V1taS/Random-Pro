//
//  PremiumScreenPurchaseState.swift
//  PremiumScreenModule
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import ApplicationInterface

enum PremiumScreenPurchaseState: AppPurchasesServiceStateProtocol {
  /// Успешная покупка подписки
case successfulSubscriptionPurchase
  
  /// Успешная разовая покупка
case successfulOneTimePurchase
  
  /// Что-то пошло не так
case somethingWentWrong
}
