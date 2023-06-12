//
//  FortuneWheelModel+Slices.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Slices

extension FortuneWheelModel {
  
  /// Данные для отображения
  var slices: [Slice] {
    switch style {
    case .regular:
      return selectedSection.objects.enumerated().compactMap { index, object in
        var slice = Slice(contents: [
          .text(text: object.title, preferences: titlePreferences)
        ])
        let colorIndex = index % wheelColors.count
        slice.backgroundColor = wheelColors[colorIndex]
        return slice
      }
    }
  }
}
