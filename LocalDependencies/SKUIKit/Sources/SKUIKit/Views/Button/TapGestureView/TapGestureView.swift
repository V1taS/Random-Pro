//
//  TapGestureView.swift
//
//
//  Created by Vitalii Sosin on 09.12.2023.
//

import SwiftUI
import SKStyle

public struct TapGestureView<Content: View>: View {
  
  // MARK: - Private properties
  
  private let style: Style
  private let isSelectable: Bool
  private let isImpactFeedback: Bool
  private let touchesBegan: (() -> Void)?
  private let touchesEnded: () -> Void
  private let content: () -> Content
  
  private let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
  
  // MARK: - Initialization
  
  /// Инициализатор для создания основной кнопки
  /// - Parameters:
  ///   - style: Стиль вью
  ///   - isEnabled: Можно ли нажать на ячейку
  ///   - isImpactFeedback: Тактильная обратная связь
  ///   - content: Контент
  ///   - touchesBegan: Замыкание, которое будет выполняться при нажатии на вью
  ///   - touchesEnded: Замыкание, которое будет выполняться в конце выполнения кнопки
  public init(
    style: TapGestureView.Style = .flash,
    isSelectable: Bool = true,
    isImpactFeedback: Bool = true,
    touchesBegan: (() -> Void)? = nil,
    touchesEnded: @escaping () -> Void,
    content: @escaping () -> Content
  ) {
    self.style = style
    self.isSelectable = isSelectable
    self.isImpactFeedback = isImpactFeedback
    self.touchesBegan = touchesBegan
    self.touchesEnded = touchesEnded
    self.content = content
  }
  
  // MARK: - Body
  
  public var body: some View {
    Button(action: {
      if isImpactFeedback {
        impactFeedback.impactOccurred()
      }
      touchesEnded()
    }) {
      content()
    }
    .buttonStyle(TapGestureFlashStyle(
      style: style,
      touchesBegan: {
        touchesBegan?()
      }
    ))
    .disabled(!isSelectable)
  }
}

// MARK: - Preview

struct TapGestureView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      HStack {
        Spacer()
      }
      Spacer()
      TapGestureView(
        style: .animationZoomOut,
        touchesEnded: {}
      ) {
        ZStack {
          SKStyleAsset.navy.swiftUIColor
          Text("Кнопка")
        }
      }
      .frame(width: 200, height: 200)
      Spacer()
    }
    .padding(.top, .s26)
    .padding(.horizontal)
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
