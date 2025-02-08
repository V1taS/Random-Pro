//
//  CGFloat+gridStep.swift
//  SKStyle
//
//  Created by Vladimir Stepanchikov on 7/21/24.
//

import UIKit

extension CGFloat {
  /// Возвращает значение, равное количеству шагов сетки, умноженному на размер шага.
  /// - Parameters:
  ///   - steps: Количество шагов сетки.
  ///   - stepSize: Размер одного шага сетки. Значение по умолчанию - 4.
  /// - Returns: Значение в единицах CGFloat, равное количеству шагов сетки, умноженному на размер шага.
  public static func gridValue(forSteps steps: Int, withStepSize stepSize: CGFloat = 4) -> CGFloat {
    return CGFloat(steps) * stepSize
  }
}
