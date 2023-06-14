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
  ///  - startSelectedSegmentIndex: Первоначальный индекс выбранного элемента у SelectedControll
  case squircleImageAndLabelWithSegmentedControl(squircleBGColors: [UIColor],
                                                 leftSideImageSystemName: String,
                                                 title: String,
                                                 startSelectedSegmentIndex: Int)
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - squircleBGColors: Squircle цвет фона
  ///  - squircleBGAlpha: Squircle прозрачность
  ///  - leftSideImage: Картинка слева в squircle
  ///  - leftSideImageColor: Цвет картинки слева
  ///  - titleText: Заголовок у ячейки
  ///  - isResultSwitch: Значение у переключателя
  case squircleImageAndLabelWithSwitchControl(squircleBGColors: [UIColor],
                                              leftSideImage: UIImage?,
                                              leftSideImageColor: UIColor?,
                                              titleText: String?,
                                              isResultSwitch: Bool)
  
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

    /// Секция поделиться
    case shareSections
  }
}
