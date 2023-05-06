//
//  SelecteAppIconScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - SelecteAppIconScreenType

/// Моделька для таблички
enum SelecteAppIconScreenType {
  
  /// Секция `Заголовок и переключатель`
  /// - Parameters:
  ///  - imageName: Имя изображения
  ///  - title: Текст
  ///  - isSetCheakmark: Установить галочки в ячейке
  ///  - isSetLocked: Установить замочек на иконке
  ///  - iconType: Тип иконки
  case largeImageAndLabelWithCheakmark(imageName: String,
                                       title: String?,
                                       isSetCheakmark: Bool,
                                       isSetLocked: Bool,
                                       iconType: SelecteAppIconType)
  
  /// Секция отступа
  case insets(Double)
  
  /// Разделитель
  case divider
}
