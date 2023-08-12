//
//  SwiftUIModifiers.swift
//  Random
//
//  Created by Nikita Ivlev on 7/5/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import SwiftUI
import FancyUIKit
import FancyStyle

// Структура копирует стиль кнопки из ButtonView в RandomUIKit
// Для копировния необходимо просто подписать кнопку под модификатор .gradientButtonStyle()
struct GradientButtonModifier: ViewModifier {
  @State private var isPressed = false
  
  var gradientBackground: [Color]
  
  init(gradientBackground: [Color]? = nil) {
    self.gradientBackground = gradientBackground ?? [
      Color(fancyColor.only.primaryGreen),
      Color(fancyColor.only.secondaryGreen)]
  }
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: 18, weight: .medium))
      .foregroundColor(.white)
      .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
      .frame(height: 52)
      .background(LinearGradient(gradient: Gradient(colors: gradientBackground), startPoint: .top, endPoint: .bottom))
      .cornerRadius(8)
      .opacity(isPressed ? 0.9 : 1)
      .scaleEffect(isPressed ? 0.95 : 1)
      .animation(.easeInOut(duration: 0.2), value: isPressed)
      .simultaneousGesture(LongPressGesture(minimumDuration: .infinity).onChanged { _ in
        isPressed = true
      }.onEnded { _ in
        isPressed = false
      })
  }
}

extension View {
  func gradientButtonStyle(gradientBackground: [Color]? = nil) -> some View {
    self.modifier(GradientButtonModifier(gradientBackground: gradientBackground))
  }
}
