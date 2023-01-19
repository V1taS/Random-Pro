//
//  PremiumScreenOnboardingViewModel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import RandomUIKit

struct PremiumScreenOnboardingViewModel: OnboardingViewModelProtocol {
  var pageModels: [RandomUIKit.OnboardingViewPageModelProtocol]
  
  var didChangePageAction: ((Int) -> Void)?
  
}

struct PremiumScreenOnboardingPageViewModel: OnboardingViewPageModelProtocol {
  var title: String?
  
  var description: String?
  
  var lottieAnimationJSONName: String
}
