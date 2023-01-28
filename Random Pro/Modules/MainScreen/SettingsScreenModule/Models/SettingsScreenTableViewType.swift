//
//  SettingsScreenTableViewType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 21.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import Foundation

// MARK: - SettingsScreenTableViewType

/// Моделька для таблички
enum SettingsScreenTableViewType {
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - isEnabled: Переключатель
  case titleAndSwitcher(title: String, isEnabled: Bool)
  
  /// Секция `Заголовок и описание`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - description: Описание
  case titleAndDescription(title: String, description: String)
  
  /// Секция `Заголовок и иконка сбоку`
  /// - Parameters:
  ///  - title: Заголовок
  ///  - id: ID Секции
  case titleAndChevron(title: String, id: String = "")
  
  /// Кнопка очистеть
  /// - Parameter title: Название кнопки
  case cleanButtonModel(title: String?)
  
  /// Секция отступа
  case insets(Double)
  
  /// Разделитель
  case divider
}
