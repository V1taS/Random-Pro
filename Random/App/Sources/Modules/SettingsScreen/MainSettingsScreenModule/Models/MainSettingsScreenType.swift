//
//  MainSettingsScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - MainSettingsScreenType

/// Моделька для таблички
enum MainSettingsScreenType {
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - squircleBGColors: Фон сквиркла
  ///  - leftSideImageSystemName: Изображение слева
  ///  - title: Заголовок
  ///  - isEnabled: Переключатель

  case squircleImageAndLabelWithSegmentedControl(squircleBGColors: [UIColor],
                                                 leftSideImageSystemName: String,
                                                 title: String,
                                                 isEnabled: Bool?)

//  case squircleImageAndLabelWithSwitch(squircleBGColors: [UIColor],
//                                       leftSideImageSystemName: String,
//                                       title: String,
//                                       isEnabled: Bool)
  
  /// Секция `Заголовок и иконка сбоку`
  /// - Parameters:
  ///  - squircleBGColors: Фон сквиркла
  ///  - leftSideImageSystemName: Изображение слева
  ///  - title: Заголовок
  ///  - type: Тип секции
  case squircleImageAndLabelWithChevronCell(squircleBGColors: [UIColor],
                                            leftSideImageSystemName: String,
                                            title: String,
                                            type: SectionType)
  
  /// Секция отступа
  case insets(Double)
  
  /// Разделитель
  case divider
  
  /// Тип выбранной секции
  enum SectionType {
    
    /// Раздел настройки главных секций
    case customMainSections
    
    /// Раздел Премиум
    case premiumSections
    
    /// Секция выбора иконок
    case applicationIconSections
  }
}
