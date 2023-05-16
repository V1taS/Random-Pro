//
//  PasswordScreenCrackTimeType.swift
//  Random
//
//  Created by Vitalii Sosin on 13.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

/// Тип времени взлома пароля
enum PasswordScreenCrackTimeType {
  
  /// Взлом в количестве дней
  case days(Int)
  
  /// Взлом в количестве месяцев
  case months(Int)
  
  /// Взлом в количестве лет
  case years(Int)
  
  /// Взлом в количестве веков
  case centuries(Int)
  
  /// Взлом в количестве веков (очень большое число)
  case overmuch(_ centuries: Int)
}
