//
//  RoundButtonView.swift
//
//
//  Created by Vitalii Sosin on 10.12.2023.
//

import SwiftUI
import SKStyle

public struct RoundButtonView: View {
  
  // MARK: - Private properties
  
  private var isSelected: Bool?
  private var isEnabled: Bool
  private let style: RoundButtonView.Style
  private let action: () -> Void
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - isEnabled: Кнопка включена
  ///   - style: Стиль кнопки
  ///   - action: Замыкание, которое будет выполняться при нажатии на кнопку
  ///   - isSelected: Включить или выключить выделение у кнопки
  ///   - onChange: Акшен на каждый ввод с клавиатуры
  public init(isEnabled: Bool = true,
              style: RoundButtonView.Style,
              isSelected: Bool? = nil,
              action: @escaping () -> Void) {
    self.isEnabled = isEnabled
    self.style = style
    self.isSelected = isSelected
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    createRoundButtonView()
  }
}

// MARK: - Private

private extension RoundButtonView {
  func createRoundButtonView() -> AnyView {
    AnyView(
      TapGestureView(
        style: .animationZoomOut,
        isSelectable: isEnabled,
        touchesEnded: {
          action()
        }
      ) {
        HStack(alignment: .center, spacing: .s2) {
          if let image = style.image {
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: .s4, height: .s4)
              .if(style.imageColor != nil) { view in
                view
                  .foregroundColor(style.imageColor ?? SKStyleAsset.ghost.swiftUIColor)
              }
              .allowsHitTesting(false)
          }
          
          if let text = style.text {
            Text(text)
              .font(.fancy.text.regularMedium)
              .foregroundColor(SKStyleAsset.ghost.swiftUIColor)
              .lineLimit(1)
              .truncationMode(.tail)
              .multilineTextAlignment(.center)
          }
        }
        .if(
          isSelected != nil,
          transform: {
            view in
            let isSelected = self.isSelected ?? false
            return view.roundedEdge(
              backgroundColor: isSelected ? style.backgroundColor : .clear
            )
          },
          else: { view in
            view.roundedEdge(backgroundColor: style.backgroundColor)
          }
        )
      }
    )
  }
}

// MARK: - Preview

struct RoundButtonView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      HStack {
        RoundButtonView(
          style: .copy(text: "Copy"),
          action: {}
        )
        RoundButtonView(
          style: .custom(text: "Max"),
          action: {}
        )
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
