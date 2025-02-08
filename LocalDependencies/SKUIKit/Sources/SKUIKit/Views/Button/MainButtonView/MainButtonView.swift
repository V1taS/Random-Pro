//
//  MainButtonView.swift
//
//
//  Created by Vitalii Sosin on 01.12.2023.
//

import SwiftUI
import SKStyle

public struct MainButtonView: View {
  
  // MARK: - Private properties
  
  private let text: String
  private let isEnabled: Bool
  
  private let style: MainButtonView.Style
  private let action: () -> Void
  
  // MARK: - Initialization
  
  /// Инициализатор для создания основной кнопки
  /// - Parameters:
  ///   - text: Текст, который будет отображаться на кнопке
  ///   - isEnabled: Кнопка включена
  ///   - style: Стиль кнопки
  ///   - action: Замыкание, которое будет выполняться при нажатии на кнопку
  public init(text: String,
              isEnabled: Bool = true,
              style: MainButtonView.Style = .primary,
              action: @escaping () -> Void) {
    self.text = text
    self.style = style
    self.isEnabled = isEnabled
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    TapGestureView(
      style: .animationZoomOut,
      isSelectable: isEnabled,
      touchesEnded: { action() }
    ) {
      ZStack {
        LinearGradient(
          gradient: Gradient(
            colors: isEnabled ? style.enabledColors : style.disabledColors
          ),
          startPoint: .leading,
          endPoint: .trailing
        )
        
        Text(text)
          .font(.fancy.text.regularMedium)
          .foregroundColor(style.textButtonColor)
          .padding(.s4)
          .frame(maxWidth: .infinity)
          .lineLimit(Constants.lineLimit)
          .truncationMode(.tail)
      }
      .clipShape(RoundedRectangle(cornerRadius: .s4))
      .frame(height: .s13)
    }
  }
}

// MARK: - Constants

private enum Constants {
  static let lineLimit = 1
}

// MARK: - Preview

struct MainButtonView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Spacer()
      VStack {
        MainButtonView(
          text: "Кнопка primary",
          isEnabled: true,
          style: .primary,
          action: {}
        )
        
        MainButtonView(
          text: "Кнопка secondary",
          isEnabled: true,
          style: .secondary,
          action: {}
        )
      }
      Spacer()
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
