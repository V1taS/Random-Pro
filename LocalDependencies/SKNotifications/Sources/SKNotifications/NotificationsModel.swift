//
//  NotificationsModel.swift
//
//
//  Created by Vitalii Sosin on 08.07.2022.
//

import UIKit

/// Модель для уведомлений
public struct NotificationsModel {
  
  /// Псевдоним для экшена
  public typealias Action = () -> Void
  
  public enum Style {
    
    /// Нейтральный
    case neutral(colorGlyph: UIColor?)
    
    /// Негативный
    case negative(colorGlyph: UIColor?)
    
    /// Позитивный
    case positive(colorGlyph: UIColor?)
    
    /// Настраиваемый
    ///  - Parameters:
    ///    - backgroundColor: Цвет фона уведомления
    ///    - glyph: Иконка слева
    ///    - colorGlyph: Цвет иконки
    case custom(backgroundColor: UIColor?, glyph: UIImage?, colorGlyph: UIColor?)
    
    /// Цвет фона уведомления
    var backgroundColor: UIColor? {
      switch self {
      case .neutral:
        if #available(iOS 13.0, *) {
          return .systemGray3
        } else {
          return .gray
        }
      case .negative:
        return Appearance().redColor
      case .positive:
        return .systemGreen
      case .custom(let backgroundColor, _, _):
        return backgroundColor
      }
    }
    
    /// Иконка слева
    var imageResource: UIImage? {
      let appearance = Appearance()
      switch self {
      case .neutral, .negative: return appearance.warningRing
      case .positive: return appearance.checkmarkRing
      case .custom(_, let glyph, _): return glyph
      }
    }
    
    /// Цвет иконки
    var colorGlyph: UIColor? {
      switch self {
      case .neutral(let colorGlyph):
        let color: UIColor? = colorGlyph == nil ? .black : colorGlyph
        return color
      case .negative(let colorGlyph):
        let color: UIColor? = colorGlyph == nil ? .black : colorGlyph
        return color
      case .positive(let colorGlyph):
        return colorGlyph
      case .custom(_, _, let colorGlyph): return colorGlyph
      }
    }
  }
  
  /// Текст уведомления
  let body: String
  
  /// Цвет текста уведомления
  let bodyColor: UIColor?
  
  /// Стиль уведомления
  let style: Style
  
  /// Время показа уведомления
  let timeout: TimeInterval?
  
  /// Иконка слева. По умолчанию выключена
  let glyph: Bool
  
  /// Задержка перед показом
  let throttleDelay: Double
  
  /// Экшен на нажатие уведомления
  let action: Action?
  
  /// Модель для уведомлений
  /// - Parameters:
  ///  - text: Текст уведомления
  ///  - textColor: Цвет текста уведомления
  ///  - style: Стиль уведомления
  ///  - timeout: Время показа уведомления
  ///  - glyph: Иконка слева. По умолчанию выключена
  ///  - throttleDelay: Задержка перед показом
  ///  - action: Экшен на нажатие уведомления
  public init(
    text: String,
    textColor: UIColor?,
    style: Style = .negative(colorGlyph: .black),
    timeout: TimeInterval? = nil,
    glyph: Bool = false,
    throttleDelay: Double = 0.5,
    action: Action? = nil
  ) {
    self.body = text
    self.bodyColor = textColor
    self.style = style
    self.timeout = timeout
    self.glyph = glyph
    self.throttleDelay = throttleDelay
    self.action = action
  }
}

// MARK: - Appearance

private extension NotificationsModel {
  struct Appearance {
    let checkmarkRing = UIImage(named: "checkmarkRing", in: .module, compatibleWith: nil)
    let warningRing = UIImage(named: "warningRing", in: .module, compatibleWith: nil)
    let redColor = UIColor.init(red: 240 / 255, green: 73 / 255, blue: 73 / 255, alpha: 1)
  }
}
