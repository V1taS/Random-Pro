//
//  MainButtonView+Model.swift
//
//
//  Created by Vitalii Sosin on 13.12.2023.
//

import SwiftUI
import SKStyle

// MARK: - Style

extension MainButtonView {
  public enum Style {
    /// Цвет текста у кнопки
    var textButtonColor: Color {
      switch self {
      case .transparentText:
        return SKStyleAsset.ghost.swiftUIColor
      case .critical:
        return SKStyleAsset.constantRuby.swiftUIColor
      default:
        return SKStyleAsset.constantGhost.swiftUIColor
      }
    }
    
    /// Стиль активной кнопки
    var enabledColors: [Color] {
      switch self {
      case .primary:
        return Constants.primaryEnabledColors
      case .secondary:
        return Constants.secondaryEnabledColors
      case .critical:
        return Constants.transparentTextColors
      case .transparentText:
        return Constants.transparentTextColors
      }
    }
    
    /// Стиль не активной кнопки
    var disabledColors: [Color] {
      switch self {
      case .primary:
        return Constants.primaryDisabledColors
      case .secondary:
        return Constants.secondaryDisabledColors
      case .critical:
        return Constants.transparentTextColors
      case .transparentText:
        return Constants.transparentTextColors
      }
    }
    
    /// Основной стиль
    case primary
    /// Вторичный стиль
    case secondary
    /// Стиль для важных действий (красная кнопка)
    case critical
    /// Стиль с прозрачным фоном и видимым только текстом
    case transparentText
  }
}

// MARK: - Constants

private enum Constants {
  static let primaryEnabledColors: [Color] = [
    SKStyleAsset.constantAzure.swiftUIColor,
    SKStyleAsset.constantAzure.swiftUIColor.opacity(0.8)
  ]
  static let primaryDisabledColors: [Color] = [
    SKStyleAsset.constantAzure.swiftUIColor.opacity(0.3),
    SKStyleAsset.constantAzure.swiftUIColor.opacity(0.2)
  ]
  
  static let secondaryEnabledColors: [Color] = [
    SKStyleAsset.constantNavy.swiftUIColor,
    SKStyleAsset.constantNavy.swiftUIColor.opacity(0.8)
  ]
  static let secondaryDisabledColors: [Color] = [
    SKStyleAsset.constantNavy.swiftUIColor.opacity(0.3),
    SKStyleAsset.constantNavy.swiftUIColor.opacity(0.2)
  ]
  static let transparentTextColors: [Color] = [ .clear, .clear]
}
