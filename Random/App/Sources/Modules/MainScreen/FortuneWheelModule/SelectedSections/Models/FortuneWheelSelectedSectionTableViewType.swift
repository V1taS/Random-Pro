//
//  FortuneWheelSelectedSectionTableViewType.swift
//  Random
//
//  Created by Vitalii Sosin on 18.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum FortuneWheelSelectedSectionTableViewType {
  
  /// Секция отступа
  case insets(Double)
  
  /// Секция кастомного текста
  case headerText(_ text: String)
  
  /// Секции колеса удачи
  case wheelSection(_ section: FortuneWheelModel.Section)
}
