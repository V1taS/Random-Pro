//
//  FeatureToggleType.swift
//  Random
//
//  Created by Vitalii Sosin on 05.08.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum FeatureToggleType: String {
  
  /// Включается экран заглушка на приложении
  case isAppBroken
  
  /// Экран перекроет все приложение, надо обязательно обновиться
  case isForceUpdateAvailable
  
  /// Если true то пользователи видео уведомление сверху экрана, что вышла новая версия приложения
  case isUpdateAvailable
  
  /// Функционал приведи 5-ти друзей и получи премиум на 1 устройство
  case isPremiumWithFriends
  
  /// Погупка навсегда (Распродажа)
  case isLifetimeSale
}
