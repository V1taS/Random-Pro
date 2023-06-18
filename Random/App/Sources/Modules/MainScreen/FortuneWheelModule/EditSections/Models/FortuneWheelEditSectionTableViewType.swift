//
//  FortuneWheelEditSectionTableViewType.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum FortuneWheelEditSectionTableViewType {
  
  /// Секция отступа
  case insets(Double)
  
  /// Секция кастомного текста
  case headerText(_ text: String)
  
  /// Секции колеса удачи
  case wheelObject(_ object: String)
  
  /// Добавление объекта в секцию
  case textfieldAddSection(_ text: String?)
  
  /// Добавление объекта в секцию
  case textfieldAddObjects
}
