//
//  KeyboardService.swift
//  ApplicationServices
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import UIKit

// MARK: - KeyboardServiceProtocol

/// Сервис клавиатуры
public protocol KeyboardServiceProtocol {
  
  /// Действие, изменения высоты клавиатуры
  ///  - Parameter height: Высота клавиатуры
  var keyboardHeightChangeAction: ((CGFloat) -> Void)? { get set }
  
  /// Действие, изменения высоты клавиатуры
  ///  - Parameter rect: Расположение и размеры прямоугольника.
  var keyboardRectChangeAction: ((CGRect) -> Void)? { get set }
}
