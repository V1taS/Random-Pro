//
//  FortuneWheelModel+TextPreferences.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Title preferences

extension FortuneWheelModel {
  
  /// Стиль заголовка
  var titlePreferences: TextPreferences {
    switch style {
    case .regular:
      var textPreferences = TextPreferences(
        textColorType: .customPatternColors(
          colors: nil,
          defaultColor: RandomColor.only.primaryWhite
        ),
        font: RandomFont.primaryBold16,
        verticalOffset: 4
      )
      textPreferences.orientation = .vertical
      textPreferences.alignment = .left
      textPreferences.numberOfLines = .zero
      textPreferences.flipUpsideDown = false
      return textPreferences
    }
  }
}
