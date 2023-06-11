//
//  FortuneWheelModel+SpinImage.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import RandomUIKit
import UIKit

// MARK: - Spin image name

extension FortuneWheelModel {
  
  /// Иконка кнопки по центру круга
  var spinImageName: String? {
    switch style {
    case .regular:
      return RandomAsset.fortuneWheelSpinDarkBlue.name
    }
  }
}
