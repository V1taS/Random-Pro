//
//  KeyboardService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol KeyboardService {

  /// Действие, изменения высоты клавиатуры
  ///  - Parameter height: Высота клавиатуры
  var keyboardHeightChangeAction: ((CGFloat) -> Void)? { get set }

  /// Действие, изменения высоты клавиатуры
  ///  - Parameter rect: Расположение и размеры прямоугольника.
  var keyboardRectChangeAction: ((CGRect) -> Void)? { get set }
}
