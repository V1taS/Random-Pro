//
//  OnboardingScreenModel.swift
//  Random
//
//  Created by Artem Pavlov on 17.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import RandomUIKit

enum OnboardingScreenModel {

  /// Приветственный Онбординг
  /// - onboardingPage: Моделька с экранами
  case onboardingPage(_ models: [OnboardingViewModel.PageModel])
}
