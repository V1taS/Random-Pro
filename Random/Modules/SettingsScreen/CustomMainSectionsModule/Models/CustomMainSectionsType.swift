//
//  CustomMainSectionsType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - CustomMainSectionsType

/// Моделька для таблички
enum CustomMainSectionsType {
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - isEnabled: Переключатель
  ///  - type: Тип секции
  case titleAndSwitcher(title: String,
                        isEnabled: Bool,
                        type: MainScreenModel.Section)
  
  /// Секция отступа
  case insets(Double)
  
  /// Разделитель
  case divider
}
