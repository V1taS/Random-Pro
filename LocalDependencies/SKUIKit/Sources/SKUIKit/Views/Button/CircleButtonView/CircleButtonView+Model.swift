//
//  CircleButtonView+Model.swift
//
//
//  Created by Vitalii Sosin on 13.12.2023.
//

import SwiftUI
import SKStyle

// MARK: - ButtonSize

extension CircleButtonView {
  public enum ButtonSize {
    var buttonSize: CGFloat {
      switch self {
      case .large:
        return .s14
      case .standart:
        return .s11
      case .small:
        return .s9
      }
    }
    
    /// Большая кнопка
    case large
    /// Стандартная кнопка
    case standart
    /// Маленькая кнопка
    case small
  }
}

// MARK: - ButtonType

extension CircleButtonView {
  public enum ButtonType {
    var imageSystemName: String {
      switch self {
      case .send:
        return "arrow.up"
      case .receive:
        return "arrow.down"
      case .share:
        return "square.and.arrow.up"
      case let .custom(systemNameImage):
        return systemNameImage
      }
    }
    
    /// Отправить
    case send
    /// Получить
    case receive
    /// Поделиться
    case share
    /// Пользовательская картинка
    case custom(systemNameImage: String)
  }
}

// MARK: - ButtonType

extension CircleButtonView {
  public enum Style {
    var buttonColor: Color {
      switch self {
      case .standart:
        return SKStyleAsset.navy.swiftUIColor
      case let .custom(color):
        return color
      }
    }
    
    /// Стандартный цвет
    case standart
    /// Пользовательский цвет
    case custom(color: Color)
  }
}
