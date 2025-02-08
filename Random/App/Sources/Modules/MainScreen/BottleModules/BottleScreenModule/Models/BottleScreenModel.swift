//
//  BottleScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 03.09.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

/// Модель стиля бутылочки
struct BottleScreenModel: UserDefaultsCodable {

  /// Стиль бутылочки
  let bottleStyle: BottleStyleSelectionScreenModel.BottleStyle
}
