//
//  RoundButtonView+Model.swift
//
//
//  Created by Vitalii Sosin on 13.12.2023.
//

import SwiftUI
import SKStyle

// MARK: - Style

extension RoundButtonView {
  public enum Style {
    var backgroundColor: Color {
      switch self {
      case let .custom(_, _, _, backgroundColor):
        return backgroundColor ?? SKStyleAsset.navy.swiftUIColor
      default:
        return SKStyleAsset.navy.swiftUIColor
      }
    }
    
    var imageColor: Color? {
      switch self {
      case let .custom(_, _, color,_):
        return color ?? SKStyleAsset.ghost.swiftUIColor
      case .copy:
        return SKStyleAsset.ghost.swiftUIColor
      }
    }
    
    var text: String? {
      switch self {
      case let .custom(_, text, _,_):
        return text
      case let .copy(text):
        return text
      }
    }
    
    var image: Image? {
      switch self {
      case let .custom(image, _, _,_):
        guard let image else {
          return nil
        }
        return image
      case .copy:
        return Image(systemName: "rectangle.on.rectangle")
      }
    }
    
    /// Пользовательские настройки
    case custom(
      image: Image? = nil,
      text: String? = nil,
      imageColor: Color? = nil,
      backgroundColor: Color? = nil
    )
    /// Копировать
    case copy(text: String)
  }
}
