//
//  FortuneWheelModel+PinImage.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomWheel
import FancyUIKit
import FancyStyle
import UIKit

// MARK: - Pin image name

extension FortuneWheelModel {
  
  /// Иконка стрелочки
  var pinImageName: String? {
    switch style {
    case .regular:
      return RandomAsset.fortuneWheelArrowDownGreen.name
    }
  }
}
