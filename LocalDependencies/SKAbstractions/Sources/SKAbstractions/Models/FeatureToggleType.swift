//
//  FeatureToggleType.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public enum FeatureToggleType: String {

  /// Включается экран заглушка на приложении
  case isAppBroken

  /// Экран перекроет все приложение, надо обязательно обновиться
  case isForceUpdateAvailable
  
  /// Если true то пользователи видят уведомление сверху экрана, что вышла новая версия приложения
  case isUpdateAvailable

  /// Покупка навсегда (Распродажа)
  case isLifetimeSale
}
