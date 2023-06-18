//
//  FortuneWheelModel+WheelColors.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Wheel сolors

extension FortuneWheelModel {
  
  /// Цвета для секций в круге
  var wheelColors: [UIColor] {
    switch style {
    case .regular:
      return [
        UIColor(hexString: "#F0C322"),
        UIColor(hexString: "#E87C24"),
        UIColor(hexString: "#E14D3E"),
        UIColor(hexString: "#DF2292"),
        UIColor(hexString: "#937BA4"),
        UIColor(hexString: "#129E8C"),
        UIColor(hexString: "#297FB9"),
        UIColor(hexString: "#884B9D"),
        UIColor(hexString: "#8F4070"),
        UIColor(hexString: "#344D63"),
      ]
    }
  }
}
