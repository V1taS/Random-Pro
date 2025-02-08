//
//  CircleButtonView.swift
//
//
//  Created by Vitalii Sosin on 03.12.2023.
//

import SwiftUI
import SKStyle

public struct CircleButtonView: View {
  
  // MARK: - Private properties
  
  private var isEnabled: Bool
  private let text: String?
  private let type: CircleButtonView.ButtonType
  private let size: CircleButtonView.ButtonSize
  private let style: CircleButtonView.Style
  private let action: () -> Void
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - isEnabled: Кнопка включена
  ///   - text: Текст, который будет отображаться под кнопкой
  ///   - type: Тип кнопки
  ///   - size: Размер кнопки
  ///   - action: Замыкание, которое будет выполняться при нажатии на кнопку
  public init(
    isEnabled: Bool = true,
    text: String? = nil,
    type: CircleButtonView.ButtonType,
    size: CircleButtonView.ButtonSize = .standart,
    style: CircleButtonView.Style = .standart,
    action: @escaping () -> Void
  ) {
    self.isEnabled = isEnabled
    self.text = text
    self.type = type
    self.size = size
    self.style = style
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    VStack {
      createCircleButtonView()
      
      if let text = text {
        Text(text)
          .font(.fancy.text.regularMedium)
          .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
          .lineLimit(Constants.lineLimit)
          .truncationMode(.tail)
          .padding(.top, .s1)
          .allowsHitTesting(false)
      }
    }
  }
}

// MARK: - Private

private extension CircleButtonView {
  func createCircleButtonView() -> AnyView {
    AnyView(
      TapGestureView(
        style: .animationZoomOut,
        isSelectable: isEnabled,
        touchesEnded: { action() }
      ) {
        ZStack {
          isEnabled ? style.buttonColor : SKStyleAsset.constantSlate.swiftUIColor.opacity(0.5)
          
          Image(systemName: type.imageSystemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
            .frame(height: size.buttonSize / 2.6)
            .allowsHitTesting(false)
        }
        .frame(width: size.buttonSize, height: size.buttonSize)
        .clipShape(Circle())
        .overlay(
          Circle().stroke(
            SKStyleAsset.constantSlate.swiftUIColor,
            lineWidth: 0.3
          )
        )
      }
    )
  }
}

// MARK: - Constants

private enum Constants {
  static let lineLimit = 1
}

// MARK: - Preview

struct CircleButtonView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        HStack {
          Spacer()
          CircleButtonView(
            text: "Отправить",
            type: .custom(systemNameImage: "arrow.up.arrow.down"),
            size: .large,
            action: {}
          )
          CircleButtonView(
            text: "Получить",
            type: .receive,
            size: .small,
            action: {}
          )
          Spacer()
        }
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
