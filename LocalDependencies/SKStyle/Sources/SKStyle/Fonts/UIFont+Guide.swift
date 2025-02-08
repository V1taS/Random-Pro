//
//  UIFont+Guide.swift
//
//  Created by Vitalii Sosin on 01.05.2022.
//

import SwiftUI

/// Расширение для `UIFont`
public extension UIFont {
  
  /// Список шрифтов
  class var fancy: UIFontGuide { UIFontGuide(text: UIFontGuide.Text(), constant: UIFontGuide.Constant()) }
}

/// Расширение для `Font`
public extension Font {
  
  /// Список шрифтов
  static var fancy: FontGuide { FontGuide(text: FontGuide.Text(), constant: FontGuide.Constant()) }
}
