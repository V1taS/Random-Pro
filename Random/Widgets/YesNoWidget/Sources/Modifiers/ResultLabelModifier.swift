//
//  ResultLabelModifier.swift
//  Random
//
//  Created by Nikita Ivlev on 7/5/23.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import SwiftUI
import FancyUIKit
import FancyStyle

// Структура копирует стиль resultLabel
// Для копировния необходимо просто подписать текст под модификатор .modifier(ResultLabelModifier(fontSize: *))
struct ResultLabelModifier: ViewModifier {
  
  var fontSize: Int
  
  init(fontSize: Int) {
    self.fontSize = fontSize
  }
  
  func body(content: Content) -> some View {
    content
      .font(.system(size: CGFloat(fontSize), weight: .bold))
      .foregroundColor(Color(fancyColor.only.primaryWhite))
      .multilineTextAlignment(.center)
  }
}
