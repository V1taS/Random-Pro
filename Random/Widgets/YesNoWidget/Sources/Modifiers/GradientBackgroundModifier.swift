//
//  GradientBackgroundModifier.swift
//  YesNoWidget
//
//  Created by Nikita Ivlev on 9/5/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import SwiftUI
import FancyUIKit
import FancyStyle

struct GradientBackgroundModifier: ViewModifier {
  var gradientBackground: [Color]

  init(gradientBackground: [Color]? = nil) {
    self.gradientBackground = gradientBackground ?? [
      Color(fancyColor.only.primaryGreen),
      Color(fancyColor.only.secondaryGreen)]
  }

  func body(content: Content) -> some View {
    content
      .background(LinearGradient(gradient: Gradient(colors: gradientBackground),
                                 startPoint: .top, endPoint: .bottom))
      .edgesIgnoringSafeArea(.all)
  }
}

extension View {
  func gradientBackgroundStyle(gradientBackground: [Color]? = nil) -> some View {
    self.modifier(GradientBackgroundModifier(gradientBackground: gradientBackground))
  }
}
