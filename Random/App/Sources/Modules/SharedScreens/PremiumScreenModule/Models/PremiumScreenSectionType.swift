//
//  PremiumScreenSectionType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import FancyUIKit
import FancyStyle

enum PremiumScreenSectionType {
  
  /// Онбординг премиум доступа
  /// - Parameter models: Моделька с экранами
  case onboardingPage(_ models: [OnboardingViewModel.PageModel])
  
  /// Карточки с выбором платных услуг
  /// - Parameters:
  ///  - leftSideCardAmount: Сумма слевой стороны
  ///  - centerSideCardAmount: Сумма по центру
  ///  - rightSideCardAmount: Сумма справой стороны
  case purchasesCards(_ leftSideCardAmount: String?,
                      _ centerSideCardAmount: String?,
                      _ rightSideCardAmount: String?)
  
  /// Ячейка с отступом
  /// - Parameter value: Значение отступа
  case padding(_ value: CGFloat)
  
  /// Разделитель
  case divider
}
