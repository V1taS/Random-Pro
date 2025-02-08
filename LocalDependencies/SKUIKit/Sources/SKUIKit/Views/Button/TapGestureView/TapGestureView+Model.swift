//
//  TapGestureView+Model.swift
//
//
//  Created by Vitalii Sosin on 13.12.2023.
//

import SwiftUI
import SKStyle

// MARK: - Style

extension TapGestureView {
  public enum Style {
    /// Кнопка нажата
    var opacityPressedDown: CGFloat {
      switch self {
      case .flash:
        return 0.8
      default:
        return 1.0
      }
    }
    
    /// Кнопка отжата
    var opacityPressedUp: CGFloat {
      return 1
    }
    
    /// Вспышка
    case flash
    
    /// Анимация уменьшения кнопки
    case animationZoomOut
    
    /// Статичная
    case none
  }
}

// MARK: - TapGestureFlashStyle

extension TapGestureView {
  struct TapGestureFlashStyle: ButtonStyle {
    
    // MARK: - Private properties
    
    private let style: Style
    private let touchesBegan: () -> Void
    
    // MARK: - Initialization
    
    /// Инициализатор для создания стиля
    /// - Parameters:
    ///   - style: Стиль вью
    ///   - touchesBegan: Замыкание, которое будет выполняться при нажатии на вью
    public init(
      style: TapGestureView.Style,
      touchesBegan: @escaping () -> Void
    ) {
      self.style = style
      self.touchesBegan = touchesBegan
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
      if configuration.isPressed {
        touchesBegan()
      }
      var scaleEffect: CGFloat = 1.0
      var animation: Bool = false
      
      if style == .animationZoomOut {
        scaleEffect = configuration.isPressed ? 0.96 : 1.0
        animation = configuration.isPressed
      }
      
      return configuration.label
        .scaleEffect(scaleEffect)
        .animation(.easeInOut(duration: 0.2), value: animation)
        .opacity(configuration.isPressed ? style.opacityPressedDown : style.opacityPressedUp)
    }
  }
}
